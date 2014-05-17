# Application Templates for Rails

http://edgeguides.rubyonrails.org/rails_application_templates.html#add-source-source-options

Minitest

```
rails new <app> --skip-bundle --database postgresql -m https://raw.github.com/brandonhilkert/rails_templates/master/default.rb
```

Rspec

```
rails new <app> --skip-bundle --skip-test-unit  --database postgresql -m https://raw.github.com/brandonhilkert/rails_templates/rspec/default.rb
```

