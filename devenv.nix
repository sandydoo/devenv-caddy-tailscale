{ pkgs, config, ... }:

{
  services.caddy = {
    enable = true;
    package = pkgs.callPackage ./caddy-tailscale.nix { };
    config = ''
      {
        tailscale {
          # If true, register ephemeral nodes that are removed after disconnect.
          # Default: false
          ephemeral true

          # Directory to store Tailscale state in. A subdirectory will be created for each node.
          # The default is to store state in the user's config dir (see os.UserConfDir).
          state_dir ${config.devenv.state}/tailscale

          foo { }

          bar { }
        }
      }

      :80 {
        bind tailscale/foo
        header Content-Type text/html
        respond <<HTML
          <html>
            <head><title>Foo</title></head>
            <body>Foo</body>
          </html>
          HTML 200
      }

      :80 {
        bind tailscale/bar
        header Content-Type text/html
        respond <<HTML
          <html>
            <head><title>Bar</title></head>
            <body>Bar</body>
          </html>
          HTML 200
      }

      :80 {
        bind tailscale/

        handle /foo* {
          reverse_proxy tailscale/foo
        }

        handle /bar* {
          reverse_proxy tailscale/bar
        }

        header Content-Type text/html
        respond <<HTML
          <html>
            <head><title>Caddy</title></head>
            <body>
              <ul>
                <li><a href=/foo</a>foo</li>
                <li><a href=/bar>bar</a></li>
              </ul>
            </body>
          </html>
          HTML 200
      }
    '';
  };

  dotenv.disableHint = true;
  packages = [ pkgs.dotenv-cli ];
  enterShell = ''
    dotenv
  '';
}
