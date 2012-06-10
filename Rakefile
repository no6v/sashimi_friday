require 'pathname'
task default: :spec

desc "prepare environment"
task :prepare do
  ENV["RUBY"] ||= "ruby"
  ENV["CURDIR"] = (cur = Pathname(__FILE__).dirname).to_s
  ENV["MSPECDIR"] ||= cur.parent.join("mspec").to_s
  ENV["RUBYSPECDIR"] ||= cur.parent.join("rubyspec").to_s
end

desc "run mspec"
task spec: :prepare do
  mspec = Pathname(ENV["MSPECDIR"]).join("bin/mspec").to_s
  if method_name = ENV["METHOD_NAME"]
    spec_file = method_name.delete("^a-z_") + "_spec.rb"
  end
  spec = Pathname(ENV["RUBYSPECDIR"]).join("core/enumerable/#{spec_file}").to_s
  exec mspec, "-I", ENV["CURDIR"], "-r", "sashimi_friday", spec
end
