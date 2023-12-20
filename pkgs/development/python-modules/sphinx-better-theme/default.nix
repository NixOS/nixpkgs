{ lib, buildPythonPackage, fetchFromGitHub, sphinxHook }:

buildPythonPackage rec {
  pname = "sphinx-better-theme";
  version = "0.1.5";
  format = "setuptools";
  outputs = [ "out" "doc" ];

  src = fetchFromGitHub {
    owner = "irskep";
    repo = "sphinx-better-theme";
    rev = "v${version}";
    sha256 = "07lhfmsjcfzcchsjzh6kxdq5s47j2a6lb5wv3m1kmv2hcm3gvddh";
  };

  nativeBuildInputs = [ sphinxHook ];

  pythonImportsCheck = [ "better" ];

  meta = with lib; {
    homepage = "https://github.com/irskep/sphinx-better-theme";
    description = "Better Sphinx Theme";
    longDescription = ''
      This is a modified version of the default Sphinx theme with the following
      goals:

      1. Remove frivolous colors, especially hard-coded ones
      2. Improve readability by limiting width and using more whitespace
      3. Encourage visual customization through CSS, not themeconf
      4. Use semantic markup

      v0.1 meets goals one and two. Goal three is partially complete; it's simple to
      add your own CSS file without creating a whole new theme.
      you'd like something changed.

      To use the theme, set ``html_theme_path`` to contain
      ``better.better_theme_path``, and set ``html_theme`` to ``'better'``::

          from better import better_theme_path
          html_theme_path = [better_theme_path]
          html_theme = 'better'
    '';
    license = licenses.bsd2;
    maintainers = with maintainers; [ kaction ];
  };
}
