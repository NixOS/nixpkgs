{ lib
, stdenv
, fetchFromGitHub
, gtk-engine-murrine
, jdupes
}:

stdenv.mkDerivation rec {
  pname = "nordic";
  version = "unstable-2022-06-21";

  srcs = [
    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "bb5e31ec1488b1fd5641aa10f65f36d8714b5dba";
      sha256 = "sha256-wTWHdao/1RLqUmqh/9gEyhERGymFWHqiC97JD28LSgk=";
      name = "Nordic";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "e1fb044a14b5c7fe1f6c2de42bfb5fdfb1448415";
      sha256 = "sha256-oWwc+bzeAf0NoYfA2r2oGpeciVUWFC7yJzlUAYfpdTY=";
      name = "Nordic-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "4c7c9f2d670a6f0c9cff1ec31fab67c826fdcc0f";
      sha256 = "sha256-txKClsygX2IUGF8oOG6gDY6Y3v28kJthjdPrPEOZarQ=";
      name = "Nordic-darker";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "8abe28ff07c190b8c343aacb6a0ce58e62abbd74";
      sha256 = "sha256-tk9VZtwpIuBcWu1ERJLnlhM71pkrNEUzu8PDb+IEnpw=";
      name = "Nordic-darker-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "9764e0f1af100731f77bf7f15792639d0032e5ed";
      sha256 = "sha256-3vxrbxUhPj6PKWpjyCruhFxYz9nPfo1DHferYUD7enU=";
      name = "Nordic-bluish-accent";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = pname;
      rev = "407316a3fd5e07d183474aea4cae28bb958afa6c";
      sha256 = "sha256-SvLTqDXjy8c4rZo0cZ83kfuiGd2+hyGvwILxVCz65jQ=";
      name = "Nordic-bluish-accent-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "1ffa167c4807e4b22e0934aee41403721877bc56";
      sha256 = "sha256-Xat5YWnxTBnvnUfs1o5EhdmDezmOXtqry97Yc8O+WYM=";
      name = "Nordic-Polar";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "${pname}-polar";
      rev = "9bc68223edf7ad9dc83032d7d51ccc53f9440337";
      sha256 = "sha256-XjGjijBky/iPcoUGDRrwwoZ5f2gbLchmQizkQN+Opjg=";
      name = "Nordic-Polar-standard-buttons";
    })
  ];

  sourceRoot = ".";

  nativeBuildInputs = [ jdupes ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    cp -a Nordic* $out/share/themes
    rm -r $out/share/themes/*/.gitignore
    rm -r $out/share/themes/*/Art
    rm -r $out/share/themes/*/LICENSE
    rm -r $out/share/themes/*/README.md
    rm -r $out/share/themes/*/{package.json,package-lock.json,Gulpfile.js}
    rm -r $out/share/themes/*/src
    rm -r $out/share/themes/*/cinnamon/*.scss
    rm -r $out/share/themes/*/gnome-shell/{extensions,*.scss}
    rm -r $out/share/themes/*/gtk-2.0/{assets.svg,assets.txt,links.fish,render-assets.sh}
    rm -r $out/share/themes/*/gtk-3.0/{apps,widgets,*.scss}
    rm -r $out/share/themes/*/xfwm4/{assets,render_assets.fish}

    # move kde related contents to appropriate directories
    mkdir -p $out/share/{aurorae/themes,color-schemes,Kvantum,plasma,sddm/themes/Nordic}
    mv -v $out/share/themes/Nordic/kde/aurorae/* $out/share/aurorae/themes/
    mv -v $out/share/themes/Nordic/kde/colorschemes/* $out/share/color-schemes/
    mv -v $out/share/themes/Nordic/kde/konsole $out/share/
    mv -v $out/share/themes/Nordic/kde/kvantum/* $out/share/Kvantum/
    mv -v $out/share/themes/Nordic/kde/plasma/look-and-feel $out/share/plasma/
    mv -v $out/share/themes/Nordic/kde/sddm/* $out/share/sddm/themes/Nordic/
    rm -rf $out/share/themes/Nordic/kde

    # Replace duplicate files with hardlinks to the first file in each
    # set of duplicates, reducing the installed size in about 65%
    jdupes -L -r $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Gtk and KDE themes using the Nord color pallete";
    homepage = "https://github.com/EliverLara/Nordic";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
