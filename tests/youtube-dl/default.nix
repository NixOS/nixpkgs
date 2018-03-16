{ runCommand, substituteAll, lighttpd, youtube-dl, curl, port ? 9987, meta ? {}, lib }:
let _port = builtins.toString port; in
runCommand "test-youtube-dl" {
  buildInputs = [
          lighttpd youtube-dl curl
          ];
  meta = lib.recursiveUpdate {
    description = "Check that ${youtube-dl.name} can handle a trivial generic page";
  } meta;
  port=_port;
  documentRoot = ./.;
} ''
  substituteAll ${./lighttpd.conf} lighttpd.conf
  lighttpd -f lighttpd.conf &
  while ! curl -I http://127.0.0.1:$port ; do
    echo waiting for lighttpd
    sleep 1
  done
  curl -v http://127.0.0.1:$port/index.html
  youtube-dl -vvvvvv http://127.0.0.1:$port/index.html -o result.mp4
  diff -sqr ${./pretend.mp4} result.mp4 | grep identical

  touch "$out"
''
