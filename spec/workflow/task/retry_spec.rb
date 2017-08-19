require 'rails_helper'

module Kuroko2::Workflow::Task
  describe Retry do
    let(:node) { Kuroko2::Workflow::ScriptParser.new(token.script).parse.find(token.path) }
    let(:definition) { create(:job_definition) }
    let(:instance) { create(:job_instance, job_definition: definition) }
    let(:script) do
      <<-EOF.strip_heredoc
        retry: 2
        execute: echo "hello, world"
      EOF
    end

    let(:token) do
      Kuroko2::Token.create(uuid: SecureRandom.uuid, job_definition: definition, job_instance: instance, script: script)
    end

    let(:task) { ParallelFork.new(node, token) }

    describe '#validate' do
      context 'with valid script format' do
        it 'passes validation' do
          expect{ task.validate }.not_to raise_error
        end
      end

      context 'with invalid option' do
        let(:script) do
          <<-EOF.strip_heredoc
            retry: B
            noop:
          EOF
        end

        it 'raises AssertionError' do
          expect{ task.validate }.to raise_error(Kuroko2::Workflow::AssertionError)
        end
      end

      context 'with invalid script format' do
        let(:script) do
          <<-EOF.strip_heredoc
            retry: 100
          EOF
        end

        it 'raises AssertionError' do
          expect{ task.validate }.to raise_error(Kuroko2::Workflow::AssertionError)
        end
      end

      context 'with multiple script format' do
        let(:script) do
          <<-EOF.strip_heredoc
            retry: 100
            execute: echo "hello, world"
            execute: echo "hello, world"
          EOF
        end

        it 'raises AssertionError' do
          expect{ task.validate }.not_to raise_error
        end
      end
    end

    describe '#execute' do
      let(:children) { token.children }

      it do
        expect(task.execute).to eq :pass
        expect(children.size).to eq 1
      end
    end

    describe '#retry' do
      context 'with invalid script format' do
        let(:script) do
          <<-EOF.strip_heredoc
            retry: 3
            execute: exit 1
          EOF
        end

        it do
          expect(task.execute).to eq :fail
          expect(children.size).to eq 1
        end
      end
    end
  end
end
