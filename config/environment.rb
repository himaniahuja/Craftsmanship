# to avoid the error "`validate_db_name': db_name must be a string or symbol (TypeError)"
require 'yaml'
YAML::ENGINE.yamler= 'syck'

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
CraftWiki::Application.initialize!
