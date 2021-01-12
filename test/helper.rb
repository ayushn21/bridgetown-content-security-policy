# frozen_string_literal: true

require "nokogiri"
require "minitest/autorun"
require "minitest/reporters"
require "minitest/profile"
require "shoulda"
require_relative "../lib/bridgetown-content-security-policy"

# Report with color.
Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new(
    color: true
  ),
]

class BridgetownContentSecurityPolicy::Test < Minitest::Test
  ROOT_DIR = File.expand_path("fixtures", __dir__)
  SOURCE_DIR = File.join(ROOT_DIR, "src")
  DEST_DIR   = File.expand_path("dest", __dir__)
  
  def setup
    @config = Bridgetown.configuration(Bridgetown::Utils.deep_merge_hashes({
      "full_rebuild" => true,
      "root_dir"     => root_dir,
      "source"       => source_dir,
      "destination"  => dest_dir,
      }, 
      config_overrides
    ))
    
    @site = Bridgetown::Site.new(@config)
    write_metadata
  end
    
  def root_dir(*files)
    File.join(ROOT_DIR, *files)
  end

  def source_dir(*files)
    File.join(SOURCE_DIR, *files)
  end

  def dest_dir(*files)
    File.join(DEST_DIR, *files)
  end

  def make_context(registers = {})
    Liquid::Context.new({}, {}, { :site => site }.merge(registers))
  end
  
  def config_overrides
    {}
  end
  
  def metadata_overrides
    {}
  end
  
  def write_metadata
    @metadata = {
      "name" => "My Awesome Site",
      "author" => {
        "name" => "Ada Lovejoy",
      }
    }
    
    metadata = @metadata.merge(metadata_overrides).to_yaml.sub("---\n", "")
    File.write(source_dir("_data/site_metadata.yml"), metadata)
    @site.process
    FileUtils.rm(source_dir("_data/site_metadata.yml"))
  end
end