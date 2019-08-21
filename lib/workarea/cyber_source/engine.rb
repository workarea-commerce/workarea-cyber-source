module Workarea
  module CyberSource
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::CyberSource
    end
  end
end
