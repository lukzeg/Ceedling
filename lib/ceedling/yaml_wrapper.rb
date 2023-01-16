require 'yaml'
require 'erb'


class YamlWrapper

  def load(filepath)
    return YAML.safe_load(ERB.new(File.read(filepath)).result, [Symbol], aliases: true)
  end

  def dump(filepath, structure)
    File.open(filepath, 'w') do |output|
      YAML.dump(structure, output)
    end
  end

end
