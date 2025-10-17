{
  fetchzip,
  lib,
  darwin,
}:
darwin.installBinaryPackage rec {
  pname = "Sequential";
  version = "2.6.0";
  src = fetchzip {
    url = "https://github.com/chuchusoft/Sequential/releases/download/v${version}/Sequential.app.2024-09-07.14.59.00.tar.xz";
    hash = "sha256-yLcwI0aluMVzUl6eNnS4ZBzp/omebNmqvNXdgY8hcTk=";
  };

  sourceRoot = "";
  appName = "Sequential.app";

  meta = with lib; {
    description = "macOS comic reader";
    longDescription = ''
      A macOS native comic reader and image viewer [CBR CBZ RAR ZIP PDF] now updated
      and built for Intel and Apple Silicon Macs running 10.14 (Intel) or 11.4 (Apple Silicon) or later.
    '';
    homepage = "https://github.com/chuchusoft/Sequential/";
    downloadPage = "${meta.homepage}/releases";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dwt ];
  };
}
