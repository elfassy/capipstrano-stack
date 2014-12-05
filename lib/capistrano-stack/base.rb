require 'erb'

def template(from, to, options = {})
  template_path = File.expand_path("../../templates/#{from}", __FILE__)
  template = ERB.new(File.new(template_path).read).result(binding)
  upload! StringIO.new(template), to

  execute :sudo, :chmod, "644 #{to}"
  execute :sudo, :chown, "root:root #{to}" if options[:as_root]
  execute :sudo, :chown, "#{options[:chown]} #{to}" if options[:chown]
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

def add_default(name, *args, &block)
  unless exists?(name)
    args[0] = send(name) << args[0]
    set(name, *args, &block) 
  end
end

def exists?(full_path)
  test '[ -d "#{full_path}" ]'
end

def put(content, file)
  upload! StringIO.new(content), file
  # Shellwords.escape(str)
end

def check_symlink(destination)
  if test '[ -h "#{destination}" ]'
    info "SUCCESS"
  else
    error "FAILED"
  end
end


