{
  curl,
  darwin,
  lib,
  netlify-cli,
  runCommand,
  stdenv,
}:

runCommand "netlify-cli-test"
  {
    nativeBuildInputs =
      [
        netlify-cli
        curl
      ]
      ++ lib.optionals stdenv.isDarwin [
        darwin.ps
      ];
    meta.timeout = 600;
  }
  ''
    mkdir home
    export HOME=$PWD/home

    # Create a simple site
    echo '<h1>hi</h1>' >index.html
    echo '/with-redirect /' >_redirects

    # Start a local server and wait for it to respond
    netlify dev --offline --port 8888 2>&1 | tee log &
    sleep 0.1 || true
    for (( i=0; i<300; i++ )); do
      if grep --ignore-case 'Server now ready' <log; then
        break
      else
        sleep 1
      fi
    done

    # Test the local server
    curl -L http://localhost:8888/with-redirect | grep '<h1>hi</h1>'

    # Success
    touch $out
  ''
