module Kuroko2
  module Workflow
    module Task
      class Retry < Base
        def validate
          unless /\A\d+(?:h|m)?\z/ === option
            raise Workflow::AssertionError,
              "A value of #{self.class.task_name} should be a number."
          end
        end

        private

        def retry_size
          option.to_i
        end

        def extract_child_nodes
          retry_size.times.each do |index|
          end
        end
      end
    end
  end
end
