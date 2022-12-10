require 'rexml/document'

# This script is for setting environment variables in OSX applications.
# 
# This script takes two arguments:
# 1) A Nix attrset serialized via `builtins.toXML'
# 2) The path to an OSX app's Info.plist file.

def main(serialized_attrs, plist_path)
  env          = attrs_to_hash(serialized_attrs)
  doc          = REXML::Document.new(File.open(plist_path, &:read))
  topmost_dict = doc.root.elements.detect { |e| e.name == "dict" }
  topmost_dict.add_element("key").tap do |key|
    key.text = "LSEnvironment"
  end
  topmost_dict.add_element(env_to_dict(env))

  formatter = REXML::Formatters::Pretty.new(2)
  formatter.compact = true
  formatter.write(doc, File.open(plist_path, "w"))
end

# Convert a `builtins.toXML' serialized attrs to a hash.
# This assumes the values are strings.
def attrs_to_hash(serialized_attrs)
  hash = {}
  env_vars = REXML::Document.new(serialized_attrs)
  env_vars.root.elements[1].elements.each do |attr|
    name = attr.attribute("name")
    value = attr.elements.first.attribute("value")
    hash[name] = value
  end
  hash
end

def env_to_dict(env)
  dict = REXML::Element.new("dict")
  env.each do |k, v|
    key = dict.add_element("key")
    key.text = k
    string = dict.add_element("string")
    string.text = v
  end
  dict
end

main(ARGV[0], ARGV[1])
