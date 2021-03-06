class ManageIQ::Providers::Amazon::Inventory::Factory
  class << self
    def inventory(ems, target)
      if target.kind_of?(EmsEvent)
        event_target(ems, target) || target(ems, ems)
      else
        target(ems, target)
      end
    end

    def target(ems, target)
      case target
      when ManageIQ::Providers::Amazon::CloudManager
        ManageIQ::Providers::Amazon::Inventory::Targets::CloudManager.new(ems, target)
      when ManageIQ::Providers::Amazon::NetworkManager
        ManageIQ::Providers::Amazon::Inventory::Targets::NetworkManager.new(ems, target)
      when ManageIQ::Providers::Amazon::StorageManager::Ebs
        ManageIQ::Providers::Amazon::Inventory::Targets::StorageManager::Ebs.new(ems, target)
      when ManageIQ::Providers::Amazon::StorageManager::S3
        ManageIQ::Providers::Amazon::Inventory::Targets::StorageManager::S3.new(ems, target)
      else
        ManageIQ::Providers::Amazon::Inventory::Targets::CloudManager.new(ems, target)
      end
    end

    def event_target(ems, target)
      case target[:full_data]["configurationItem"]["resourceType"]
      when "AWS::EC2::Instance"
        ManageIQ::Providers::Amazon::Inventory::Targets::EventPayloadVm.new(ems, target)
      end
    end
  end
end
