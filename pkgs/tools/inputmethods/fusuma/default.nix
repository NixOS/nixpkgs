{ lib, bundlerApp, bundlerUpdateScript, makeWrapper, gnugrep, libinput }:

bundlerApp {
  pname = "fusuma";
  gemdir = ./.;
  exes = [ "fusuma" ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/fusuma" \
      --prefix PATH : ${lib.makeBinPath [ gnugrep libinput ]}
  '';

  passthru.updateScript = bundlerUpdateScript "fusuma";

  meta = with lib; {
    description = "Multitouch gestures with libinput driver on X11, Linux";
    homepage = "https://github.com/iberianpig/fusuma";
    license = licenses.mit;
    maintainers = with maintainers; [ jfrankenau nicknovitski Br1ght0ne ];
    platforms = platforms.linux;
  };
}
