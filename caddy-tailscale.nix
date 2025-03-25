{ stdenv, caddy, xcaddy, git, go, cacert }:

let
  version = "2.9.1";
in
stdenv.mkDerivation {
  pname = "caddy-tailscale";
  inherit version;
  dontUnpack = true;

  nativeBuildInputs = [ git go xcaddy cacert ];

  configurePhase = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
  '';

  buildPhase = ''
    runHook preBuild
    xcaddy build v${version} --with github.com/tailscale/caddy-tailscale
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv caddy $out/bin
    runHook postInstall
  '';

  meta = caddy.meta // {
    description = "Caddy with Tailscale plugin";
  };
}
