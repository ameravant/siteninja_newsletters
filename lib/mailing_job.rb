class MailingJob < Struct.new(:blast_id)  
  def perform
    blast = NewsletterBlast.find(blast_id)
    contacts = blast.person_groups.collect(&:people).flatten.uniq
    log = Logger.new("#{RAILS_ROOT}/log/newsletter-blast-errors-#{path_safe(Time.now.to_s)}.log")
    log2 = Logger.new("#{RAILS_ROOT}/log/newsletter-blast-#{path_safe(Time.now.to_s)}.log")
    unsendable = 0
    contacts.each do |contact|
      if contact.active && !contact.no_newsletters
        begin
          #contact.first_name = "NotProvided" if contact.first_name.blank?
          #contact.last_name = "NotProvided" if contact.last_name.blank?
          PostOffice.deliver_newsletter(blast.newsletter, contact.first_name, contact.email, contact.id, blast.id, @settings) unless contact.no_newsletters
          #log2.info "#{contact.name}, #{contact.email}, #{contact.id}:\n#{$!}"
        rescue
          log.info "The following error occurred delivery to #{contact.name}, #{contact.email}, #{contact.id}:\n#{$!}"
        end
      else
        unsendable += 1
      end
    end
  end  
end  