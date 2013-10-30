guard('rspec',
      cli: '--color --format nested --fail-fast',
      all_after_pass: false,
      all_on_start:   false,
      keep_failed:    false) do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})      { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')   { "spec/" }
end

guard 'ctags-bundler', src_path: ["lib"], custom_path: "tmp", emacs: true do
  watch(/^lib\/.*\.rb$/)
  watch('Gemfile.lock')
end
