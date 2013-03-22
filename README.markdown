# Rails-FastCGI

Simple Rails application configured to be deployed on apache2 with FastCGI
You need to have FastCGI library for Ruby and FastCGI module for apache2 installed.

# Files of interest:

## public/.htaccess
<pre>
Options +FollowSymLinks +ExecCGI

RewriteEngine On

RewriteRule ^(stylesheets/.*)$ - [L]
RewriteRule ^(javascripts/.*)$ - [L]
RewriteRule ^(images/.*)$ - [L]

RewriteRule ^$ index.html [QSA]
RewriteRule ^([^.]+)$ $1.html [QSA]
RewriteCond %{REQUEST_FILENAME} !-f

RewriteRule ^(.*)$ rails_fcgi.fcgi [E=X-HTTP_AUTHORIZATION:%{HTTP:Authorization},QSA,L]
</pre>

## public/rails_fcgi.fcgi
<pre>
#!/usr/bin/ruby

require_relative '../config/environment'

class Rack::PathInfoRewriter
  def initialize(app)
    @app = app
  end

  def call(env)
    env.delete('SCRIPT_NAME')
    parts = env['REQUEST_URI'].split('?')
    env['PATH_INFO'] = parts[0]
    env['QUERY_STRING'] = parts[1].to_s
    @app.call(env)
  end
end

Rack::Handler::FastCGI.run  Rack::PathInfoRewriter.new(RailsFcgi::Application)
</pre>
