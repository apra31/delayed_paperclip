require "active_job"

module DelayedPaperclip
  class ProcessJob < ActiveJob::Base
    def self.enqueue_delayed_paperclip(instance_klass, instance_id, attachment_name)
      queue_name = instance_klass.constantize.paperclip_definitions[attachment_name][:delayed][:queue]
      set(:priority => -1000, :queue => queue_name).perform_later(instance_klass, instance_id, attachment_name.to_s)
    end

    def perform(instance_klass, instance_id, attachment_name)
      DelayedPaperclip.process_job(instance_klass, instance_id, attachment_name.to_sym)
    end
  end
end
