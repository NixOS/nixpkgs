= Adding plugin, theme or language =

To extend the wordpressPackages set, add a new line to the corresponding json
file with the codename of the package:

- `wordpress-languages.json` for language packs
- `wordpress-themes.json` for themes
- `wordpress-plugins.json` for plugins

The codename is the last part in the url of the plugin or theme page, for
example `cookie-notice` in in the url
`https://wordpress.org/plugins/cookie-notice/` or `twentytwenty` in
`https://wordpress.org/themes/twentytwenty/`.

In case of language packages, the name consists of country and language codes.
For example `de_DE` for country code `de` (Germany) and language `DE` (German).
For available translations and language codes see [upstream translation repository](https://translate.wordpress.org).

To regenerate the nixpkgs wordpressPackages set, run:

```
./generate.sh
```

After that you can commit and submit the changes.

= Usage with the Wordpress module =

The plugins will be available in the namespace `wordpressPackages.plugins`.
Using it together with the Wordpress module could look like this:

```
services.wordpress = {
  sites."blog.${config.networking.domain}" = {
    plugins = with pkgs.wordpressPackages.plugins; [
      anti-spam-bee
      code-syntax-block
      cookie-notice
      lightbox-with-photoswipe
      wp-gdpr-compliance
    ];
  };
};
```

The same scheme applies to `themes` and `languages`.
