{ pkgs, stdenv, fetchurl, python, self }:

let
in
{

} // pkgs.lib.optionalAttrs (python.majorVersion == "2.7") {


  "plone.uuid-1.0.3" = self.buildPythonPackage {
    name = "plone.uuid-1.0.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.uuid/plone.uuid-1.0.3.zip";
        md5 = "183fe2911a7d6c9f6b3103855e98ad8a";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.browserpage-3.12.2" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.publisher-3.12.6" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        UUIDs for content items
        '';
      homepage = "http://plone.org";
      license = "BSD";
    };
  };


  "six-1.2.0" = self.buildPythonPackage {
    name = "six-1.2.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/s/six/six-1.2.0.tar.gz";
        md5 = "2a5d1afc79912832ac78fd38e3d75d7e";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Python 2 and 3 compatibility utilities
        '';
      homepage = "http://pypi.python.org/pypi/six/";
      license = "UNKNOWN";
    };
  };


  "Products.ZopeVersionControl-1.1.3" = self.buildPythonPackage {
    name = "Products.ZopeVersionControl-1.1.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.ZopeVersionControl/Products.ZopeVersionControl-1.1.3.zip";
        md5 = "238239102f3ac798ee4f4c53343a561f";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self.setuptools self."transaction-1.1.1" self."ZODB3-3.10.5" self."zope.interface-3.6.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Zope Version Control
        '';
      homepage = "http://pypi.python.org/pypi/Products.ZopeVersionControl";
      license = "ZPL";
    };
  };


  "Products.Archetypes-1.9.4" = self.buildPythonPackage {
    name = "Products.Archetypes-1.9.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.Archetypes/Products.Archetypes-1.9.4.zip";
        md5 = "fc5679b10df703a542b58da044f7d9c6";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self."ExtensionClass-2.13.2" self."plone.app.folder-1.0.5" self."plone.folder-1.0.4" self."plone.uuid-1.0.3" self."Products.CMFCalendar-2.2.2" self."Products.CMFCore-2.2.7" self."Products.CMFDefault-2.2.3" self."Products.CMFFormController-3.0.3" self."Products.CMFQuickInstallerTool-3.0.6" self."Products.DCWorkflow-2.2.4" self."Products.GenericSetup-1.7.4" self."Products.Marshall-2.1.2" self."Products.MimetypesRegistry-2.0.5" self."Products.PlacelessTranslationService-2.0.4" self."Products.PortalTransforms-2.1.2" self."Products.statusmessages-4.0" self."Products.validation-2.0" self."Products.ZSQLMethods-2.13.4" self.setuptools self."transaction-1.1.1" self."ZODB3-3.10.5" self."zope.component__zcml-3.9.5" self."zope.contenttype-3.5.5" self."zope.datetime-3.4.1" self."zope.deferredimport-3.5.3" self."zope.event-3.5.2" self."zope.i18n__zcml-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.site-3.9.2" self."zope.tal-3.5.2" self."zope.viewlet-3.7.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Archetypes is a developers framework for rapidly developing and deploying rich, full featured content types within the context of Zope/CMF and Plone.
        '';
      homepage = "http://pypi.python.org/pypi/Products.Archetypes";
      license = "GPL";
    };
  };


  "plone.app.contentlisting-1.0.5" = self.buildPythonPackage {
    name = "plone.app.contentlisting-1.0.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.contentlisting/plone.app.contentlisting-1.0.5.zip";
        md5 = "9fc15b8ecad1c918778c3ea9a75bf533";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.uuid-1.0.3" self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Listing of content for the Plone CMS
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.contentlisting";
      license = "GPL version 2";
    };
  };


  "Products.Marshall-2.1.2" = self.buildPythonPackage {
    name = "Products.Marshall-2.1.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.Marshall/Products.Marshall-2.1.2.zip";
        md5 = "bde4d7f75195c1ded8371554b04d2541";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self."ExtensionClass-2.13.2" self."plone.uuid-1.0.3" self."Products.CMFCore-2.2.7" self."Products.GenericSetup-1.7.4" self.setuptools self."transaction-1.1.1" self."zope.contenttype-3.5.5" self."zope.interface-3.6.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Configurable Marshallers for Archetypes
        '';
      homepage = "http://pypi.python.org/pypi/Products.Marshall";
      license = "GPL";
    };
  };


  "plone.folder-1.0.4" = self.buildPythonPackage {
    name = "plone.folder-1.0.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.folder/plone.folder-1.0.4.zip";
        md5 = "1674ff18b7a9452d0c2063cf11c679b7";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.memoize-1.1.1" self.setuptools self."zope.annotation-3.5.0" self."zope.component__zcml-3.9.5" self."zope.container-3.11.2" self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        BTree-based folder implementation with order support
        '';
      homepage = "http://pypi.python.org/pypi/plone.folder";
      license = "GPL version 2";
    };
  };


  "plone.z3cform-0.8.0" = self.buildPythonPackage {
    name = "plone.z3cform-0.8.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.z3cform/plone.z3cform-0.8.0.zip";
        md5 = "bdb23dd162544964d2f8f8f5f002e874";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.batching-1.0" self.setuptools self."z3c.form-3.0.2" self."zope.browserpage-3.12.2" self."zope.component__zcml-3.9.5" self."zope.i18n__zcml-3.7.4" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        plone.z3cform is a library that allows use of z3c.form with Zope 2 and the CMF.
        '';
      homepage = "http://pypi.python.org/pypi/plone.z3cform";
      license = "ZPL 2.1";
    };
  };


  "six-1.4.1" = self.buildPythonPackage {
    name = "six-1.4.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/s/six/six-1.4.1.tar.gz";
        md5 = "bdbb9e12d3336c198695aa4cf3a61d62";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Python 2 and 3 compatibility utilities
        '';
      homepage = "http://pypi.python.org/pypi/six/";
      license = "UNKNOWN";
    };
  };


  "Products.CMFPlone-4.3.2" = self.buildPythonPackage {
    name = "Products.CMFPlone-4.3.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.CMFPlone/Products.CMFPlone-4.3.2.zip";
        md5 = "b9948583429d7d90475148d276fa5cf4";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."archetypes.querywidget-1.0.9" self."archetypes.referencebrowserwidget-2.4.19" self."borg.localrole-3.0.2" self."DateTime-3.0.3" self."ExtensionClass-2.13.2" self."five.customerize-1.1" self."five.localsitemanager-2.0.5" self."Pillow-1.7.8" self."plone.app.blob-1.5.8" self."plone.app.collection-1.0.11" self."plone.app.content-2.1.3" self."plone.app.contentlisting-1.0.5" self."plone.app.contentmenu-2.0.8" self."plone.app.contentrules-3.0.4" self."plone.app.controlpanel-2.3.7" self."plone.app.customerize-1.2.2" self."plone.app.discussion-2.2.8" self."plone.app.folder-1.0.5" self."plone.app.form-2.2.3" self."plone.app.i18n-2.0.2" self."plone.app.jquery-1.7.2" self."plone.app.jquerytools-1.5.6" self."plone.app.layout-2.3.7" self."plone.app.linkintegrity-1.5.3" self."plone.app.locales-4.3.2" self."plone.app.portlets-2.4.5" self."plone.app.redirector-1.2" self."plone.app.search-1.1.5" self."plone.app.upgrade-1.3.4" self."plone.app.users-1.2a2" self."plone.app.uuid-1.0" self."plone.app.viewletmanager-2.0.4" self."plone.app.vocabularies-2.1.11" self."plone.app.workflow-2.1.6" self."plone.batching-1.0" self."plone.browserlayer-2.1.2" self."plone.contentrules-2.0.3" self."plone.fieldsets-2.0.2" self."plone.i18n-2.0.9" self."plone.indexer-1.0.2" self."plone.intelligenttext-2.0.2" self."plone.locking-2.0.4" self."plone.memoize-1.1.1" self."plone.portlet.collection-2.1.5" self."plone.portlet.static-2.0.2" self."plone.portlets-2.2" self."plone.protect-2.0.2" self."plone.registry-1.0.1" self."plone.session-3.5.3" self."plone.theme-2.1" self."plonetheme.classic-1.3.2" self."plonetheme.sunburst-1.4.5" self."Products.Archetypes-1.9.4" self."Products.ATContentTypes-2.1.13" self."Products.CMFActionIcons-2.1.3" self."Products.CMFCalendar-2.2.2" self."Products.CMFCore-2.2.7" self."Products.CMFDefault-2.2.3" self."Products.CMFDiffTool-2.1" self."Products.CMFDynamicViewFTI-4.0.5" self."Products.CMFEditions-2.2.8" self."Products.CMFFormController-3.0.3" self."Products.CMFQuickInstallerTool-3.0.6" self."Products.CMFUid-2.2.1" self."Products.DCWorkflow-2.2.4" self."Products.ExtendedPathIndex-3.1" self."Products.ExternalEditor-1.1.0" self."Products.GenericSetup-1.7.4" self."Products.MimetypesRegistry-2.0.5" self."Products.PasswordResetTool-2.0.15" self."Products.PlacelessTranslationService-2.0.4" self."Products.PloneLanguageTool-3.2.7" self."Products.PlonePAS-4.1.1" self."Products.PluggableAuthService-1.10.0" self."Products.PluginRegistry-1.3" self."Products.PortalTransforms-2.1.2" self."Products.ResourceRegistries-2.2.9" self."Products.statusmessages-4.0" self."Products.TinyMCE-1.3.5" self.setuptools self."transaction-1.1.1" self."z3c.autoinclude-0.3.4" self."ZODB3-3.10.5" self."zope.app.locales-3.6.2" self."zope.component__zcml-3.9.5" self."zope.container-3.11.2" self."zope.deferredimport-3.5.3" self."zope.deprecation-3.4.1" self."zope.dottedname-3.4.6" self."zope.event-3.5.2" self."zope.i18n__zcml-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.location-3.9.1" self."zope.pagetemplate-3.6.3" self."zope.publisher-3.12.6" self."zope.site-3.9.2" self."zope.structuredtext-3.5.1" self."zope.tal-3.5.2" self."zope.tales-3.5.3" self."zope.traversing-3.13.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        The Plone Content Management System (core)
        '';
      homepage = "http://plone.org/";
      license = "GPL version 2";
    };
  };


  "zope.deferredimport-3.5.3" = self.buildPythonPackage {
    name = "zope.deferredimport-3.5.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.deferredimport/zope.deferredimport-3.5.3.tar.gz";
        md5 = "68fce3bf4f011d4a840902fd763884ee";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.proxy-3.6.1" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        zope.deferredimport allows you to perform imports names that will only be resolved when used in the code.
        '';
      homepage = "http://pypi.python.org/pypi/zope.deferredimport";
      license = "ZPL 2.1";
    };
  };


  "Mako-0.9.0" = self.buildPythonPackage {
    name = "Mako-0.9.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/M/Mako/Mako-0.9.0.tar.gz";
        md5 = "e2627ba5c65f83dfe39d9a0892ae517d";
    };
    doCheck = true;
    buildInputs = [ self."nose-1.3.0" ];
    propagatedBuildInputs = [ self."MarkupSafe-0.18" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        A super-fast templating language that borrows the  best ideas from the existing templating languages.
        '';
      homepage = "http://www.makotemplates.org/";
      license = "MIT";
    };
  };


  "waitress-0.8.7" = self.buildPythonPackage {
    name = "waitress-0.8.7";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/w/waitress/waitress-0.8.7.tar.gz";
        md5 = "714f3d458d82a47f12fb168460de8366";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Waitress WSGI server
        '';
      homepage = "https://github.com/Pylons/waitress";
      license = "ZPL 2.1";
    };
  };


  "coverage-3.7" = self.buildPythonPackage {
    name = "coverage-3.7";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/c/coverage/coverage-3.7.tar.gz";
        md5 = "055d82e6849d882ec6cf2ae1faca8e56";
    };
    doCheck = true;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Code coverage measurement for Python
        '';
      homepage = "http://nedbatchelder.com/code/coverage";
      license = "BSD";
    };
  };


  "Products.CMFUid-2.2.1" = self.buildPythonPackage {
    name = "Products.CMFUid-2.2.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.CMFUid/Products.CMFUid-2.2.1.tar.gz";
        md5 = "e20727959351dffbf0bac80613eee110";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."Products.CMFCore-2.2.7" self."Products.GenericSetup-1.7.4" self.setuptools self."Zope2-2.13.21" self."eggtestinfo-0.3" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Uid product for the Zope Content Management Framework
        '';
      homepage = "http://pypi.python.org/pypi/Products.CMFUid";
      license = "ZPL 2.1 (http://www.zope.org/Resources/License/ZPL-2.1)";
    };
  };


  "plone.autoform-1.5" = self.buildPythonPackage {
    name = "plone.autoform-1.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.autoform/plone.autoform-1.5.zip";
        md5 = "a62216fb76017077643f5af8b1e17949";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.supermodel-1.2.3" self."plone.z3cform-0.8.0" self.setuptools self."z3c.form-3.0.2" self."zope.dottedname-3.4.6" self."zope.interface-3.6.7" self."zope.schema-4.2.2" self."zope.security__untrustedpython-3.7.4" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Tools to construct z3c.form forms
        '';
      homepage = "http://code.google.com/p/dexterity";
      license = "LGPL";
    };
  };


  "Unidecode-0.04.1" = self.buildPythonPackage {
    name = "Unidecode-0.04.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/U/Unidecode/Unidecode-0.04.1.tar.gz";
        md5 = "c4c9ed8d40cff25c390ff5d5112b9308";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        US-ASCII transliterations of Unicode text
        '';
      homepage = "http://code.zemanta.com/tsolc/unidecode/";
      license = "UNKNOWN";
    };
  };


  "plone.fieldsets-2.0.2" = self.buildPythonPackage {
    name = "plone.fieldsets-2.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.fieldsets/plone.fieldsets-2.0.2.zip";
        md5 = "4158c8a1f784fcb5cecbd63deda7222f";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."five.formlib-1.0.4" self.setuptools self."zope.component__zcml-3.9.5" self."zope.formlib-4.0.6" self."zope.interface-3.6.7" self."zope.schema-4.2.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        An extension to zope.formlib, which allows to group fields into different fieldsets.
        '';
      homepage = "http://pypi.python.org/pypi/plone.fieldsets";
      license = "GPL version 2";
    };
  };


  "plone.app.redirector-1.2" = self.buildPythonPackage {
    name = "plone.app.redirector-1.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.redirector/plone.app.redirector-1.2.zip";
        md5 = "bc0508844f276ac7a7b9556d37281cc8";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.memoize-1.1.1" self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        redirection tool
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.redirector";
      license = "GPL version 2";
    };
  };


  "plone.app.blob-1.5.8" = self.buildPythonPackage {
    name = "plone.app.blob-1.5.8";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.blob/plone.app.blob-1.5.8.zip";
        md5 = "7e575d8df137cd19067cc95845aae604";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."archetypes.schemaextender-2.1.2" self."plone.app.imaging-1.0.9" self."plone.scale__storage-1.3.2" self.setuptools self."ZODB3-3.10.5" self."zope.proxy-3.6.1" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        ZODB blob support for Plone
        '';
      homepage = "http://plone.org/products/plone.app.blob";
      license = "GPL version 2";
    };
  };


  "WebOb-1.2.3" = self.buildPythonPackage {
    name = "WebOb-1.2.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/W/WebOb/WebOb-1.2.3.tar.gz";
        md5 = "11825b7074ba7043e157805e4e6e0f55";
    };
    doCheck = true;
    buildInputs = [ self."nose-1.3.0" ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        WSGI request and response object
        '';
      homepage = "http://webob.org/";
      license = "MIT";
    };
  };


  "zope.testbrowser-3.11.1" = self.buildPythonPackage {
    name = "zope.testbrowser-3.11.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.testbrowser/zope.testbrowser-3.11.1.tar.gz";
        md5 = "64abbee892121e7f1a91aed12cfc155a";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."mechanize-0.2.5" self."pytz-2013b" self.setuptools self."zope.interface-3.6.7" self."zope.schema-4.2.2" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Programmable browser for functional black-box tests
        '';
      homepage = "http://pypi.python.org/pypi/zope.testbrowser";
      license = "ZPL 2.1";
    };
  };


  "plone.theme-2.1" = self.buildPythonPackage {
    name = "plone.theme-2.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.theme/plone.theme-2.1.zip";
        md5 = "c592d0d095e9fc76cc81597cdf6d0c37";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Products.CMFCore-2.2.7" self."Products.CMFDefault-2.2.3" self.setuptools self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."zope.publisher-3.12.6" self."zope.traversing-3.13.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Tools for managing themes in CMF and Plone sites
        '';
      homepage = "http://pypi.python.org/pypi/plone.theme";
      license = "GPL version 2";
    };
  };


  "zope.site-3.9.2" = self.buildPythonPackage {
    name = "zope.site-3.9.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.site/zope.site-3.9.2.tar.gz";
        md5 = "36a0b8dfbd713ed452ce6973ab0a3ddb";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.annotation-3.5.0" self."zope.component__zcml-3.9.5" self."zope.container-3.11.2" self."zope.event-3.5.2" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.location-3.9.1" self."zope.security__untrustedpython-3.7.4" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Local registries for zope component architecture
        '';
      homepage = "http://pypi.python.org/pypi/zope.site";
      license = "ZPL 2.1";
    };
  };


  "plone.batching-1.0" = self.buildPythonPackage {
    name = "plone.batching-1.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.batching/plone.batching-1.0.zip";
        md5 = "cabd58ccfec67cd384602343ce40dc7b";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Batching facilities used in Plone.
        '';
      homepage = "http://pypi.python.org/pypi/plone.batching";
      license = "GPL";
    };
  };


  "Products.PlacelessTranslationService-2.0.4" = self.buildPythonPackage {
    name = "Products.PlacelessTranslationService-2.0.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.PlacelessTranslationService/Products.PlacelessTranslationService-2.0.4.zip";
        md5 = "4b5a1ddc66eeaa02d32ee4a685905c10";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self."ExtensionClass-2.13.2" self."python-gettext-1.2" self.setuptools self."ZODB3-3.10.5" self."zope.annotation-3.5.0" self."zope.component__zcml-3.9.5" self."zope.deferredimport-3.5.3" self."zope.deprecation-3.4.1" self."zope.i18n__zcml-3.7.4" self."zope.interface-3.6.7" self."zope.publisher-3.12.6" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        PTS provides a way of internationalizing (i18n'ing) and localizing (l10n'ing) software for Zope 2.
        '';
      homepage = "http://pypi.python.org/pypi/Products.PlacelessTranslationService";
      license = "GPL";
    };
  };


  "Pillow-1.7.8" = self.buildPythonPackage {
    name = "Pillow-1.7.8";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Pillow/Pillow-1.7.8.zip";
        md5 = "41d8688d4db72673069a6dc63b5289d6";
    };
    doCheck = false;
    buildInputs = [ pkgs.freetype pkgs.libjpeg pkgs.zlib pkgs.libtiff pkgs.libwebp pkgs.unzip ];
    propagatedBuildInputs = [  ];
    configurePhase = ''
      sed -i "setup.py" \
          -e 's|^FREETYPE_ROOT =.*$|FREETYPE_ROOT = _lib_include("${pkgs.freetype}")|g ;
              s|^JPEG_ROOT =.*$|JPEG_ROOT = _lib_include("${pkgs.libjpeg}")|g ;
              s|^ZLIB_ROOT =.*$|ZLIB_ROOT = _lib_include("${pkgs.zlib}")|g ;
              s|^LCMS_ROOT =.*$|LCMS_ROOT = _lib_include("${pkgs.libwebp}")|g ;
              s|^TIFF_ROOT =.*$|TIFF_ROOT = _lib_include("${pkgs.libtiff}")|g ;'
    '';
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Python Imaging Library (fork)
        '';
      homepage = "http://github.com/python-imaging/Pillow";
      license = "UNKNOWN";
    };
  };


  "ZConfig-2.9.1" = self.buildPythonPackage {
    name = "ZConfig-2.9.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/Z/ZConfig/ZConfig-2.9.1.tar.gz";
        md5 = "4738de641d90b992de5b89ff1bc2fe49";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Structured Configuration Library
        '';
      homepage = "http://www.zope.org/Members/fdrake/zconfig/";
      license = "ZPL 2.1";
    };
  };


  "zope.deprecation-3.4.1" = self.buildPythonPackage {
    name = "zope.deprecation-3.4.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.deprecation/zope.deprecation-3.4.1.tar.gz";
        md5 = "8a47b0f8e1fa4e833007e5b8351bb1d4";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Zope Deprecation Infrastructure
        '';
      homepage = "http://pypi.python.org/pypi/zope.deprecation";
      license = "ZPL 2.1";
    };
  };


  "Products.CMFFormController-3.0.3" = self.buildPythonPackage {
    name = "Products.CMFFormController-3.0.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.CMFFormController/Products.CMFFormController-3.0.3.zip";
        md5 = "6573df7dcb39e3b63ba22abe2acd639e";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."Products.CMFCore-2.2.7" self."Products.GenericSetup-1.7.4" self.setuptools self."transaction-1.1.1" self."zope.interface-3.6.7" self."zope.structuredtext-3.5.1" self."zope.tales-3.5.3" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        CMFFormController provides a form validation mechanism for CMF.
        '';
      homepage = "http://pypi.python.org/pypi/Products.CMFFormController";
      license = "BSD";
    };
  };


  "Products.validation-2.0" = self.buildPythonPackage {
    name = "Products.validation-2.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.validation/Products.validation-2.0.zip";
        md5 = "afa217e2306637d1dccbebf337caa8bf";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self.setuptools self."zope.i18n__zcml-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Data validation package for Archetypes
        '';
      homepage = "UNKNOWN";
      license = "UNKNOWN";
    };
  };


  "zope.event-4.0.2" = self.buildPythonPackage {
    name = "zope.event-4.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.event/zope.event-4.0.2.tar.gz";
        md5 = "e08dd299d428d77a1cfcbfe841b81872";
    };
    doCheck = true;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Very basic event publishing system
        '';
      homepage = "http://pypi.python.org/pypi/zope.event";
      license = "ZPL 2.1";
    };
  };


  "plone.caching-1.0" = self.buildPythonPackage {
    name = "plone.caching-1.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.caching/plone.caching-1.0.zip";
        md5 = "2c2e3b27d13b9101c92dfed222fde36c";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."five.globalrequest-1.0" self."plone.registry-1.0.1" self."plone.transformchain-1.0.3" self.setuptools self."z3c.caching__zcml-2.0a1" self."zope.component__zcml-3.9.5" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.schema-4.2.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Zope 2 integration for z3c.caching
        '';
      homepage = "http://pypi.python.org/pypi/plone.caching";
      license = "GPL";
    };
  };


  "zope.proxy-3.6.1" = self.buildPythonPackage {
    name = "zope.proxy-3.6.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.proxy/zope.proxy-3.6.1.zip";
        md5 = "a400b0a26624b17fa889dbcaa989d440";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Generic Transparent Proxies
        '';
      homepage = "http://pypi.python.org/pypi/zope.proxy";
      license = "ZPL 2.1";
    };
  };


  "zope.componentvocabulary-1.0.1" = self.buildPythonPackage {
    name = "zope.componentvocabulary-1.0.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.componentvocabulary/zope.componentvocabulary-1.0.1.tar.gz";
        md5 = "1c8fa82ca1ab1f4b0bd2455a31fde22b";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.component__zcml-3.9.5" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.schema-4.2.2" self."zope.security__untrustedpython-3.7.4" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Component vocabularies
        '';
      homepage = "http://pypi.python.org/pypi/zope.componentvocabulary";
      license = "ZPL 2.1";
    };
  };


  "Products.CMFCore-2.2.7" = self.buildPythonPackage {
    name = "Products.CMFCore-2.2.7";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.CMFCore/Products.CMFCore-2.2.7.tar.gz";
        md5 = "9320a4023b8575097feacfd4a400e930";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."five.localsitemanager-2.0.5" self."Products.GenericSetup-1.7.4" self."Products.ZSQLMethods-2.13.4" self.setuptools self."zope.app.publication-3.12.0" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Zope Content Management Framework core components
        '';
      homepage = "http://pypi.python.org/pypi/Products.CMFCore";
      license = "ZPL 2.1 (http://www.zope.org/Resources/License/ZPL-2.1)";
    };
  };


  "Products.PlonePAS-4.1.1" = self.buildPythonPackage {
    name = "Products.PlonePAS-4.1.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.PlonePAS/Products.PlonePAS-4.1.1.zip";
        md5 = "32db1808c3ad42e82542b65eb95c3c71";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.i18n-2.0.9" self."plone.memoize-1.1.1" self."plone.session-3.5.3" self."Products.CMFCore-2.2.7" self."Products.GenericSetup-1.7.4" self."Products.PluggableAuthService-1.10.0" self.setuptools self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        PlonePAS adapts the PluggableAuthService for use by Plone.
        '';
      homepage = "http://pypi.python.org/pypi/Products.PlonePAS";
      license = "ZPL";
    };
  };


  "mock-1.0.1" = self.buildPythonPackage {
    name = "mock-1.0.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/m/mock/mock-1.0.1.tar.gz";
        md5 = "c3971991738caa55ec7c356bbc154ee2";
    };
    doCheck = true;
    buildInputs = [ self."unittest2-0.5.1" ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        A Python Mocking and Patching Library for Testing
        '';
      homepage = "http://www.voidspace.org.uk/python/mock/";
      license = "UNKNOWN";
    };
  };


  "Products.ATReferenceBrowserWidget-3.0" = self.buildPythonPackage {
    name = "Products.ATReferenceBrowserWidget-3.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.ATReferenceBrowserWidget/Products.ATReferenceBrowserWidget-3.0.zip";
        md5 = "157bdd32155c8353450c17c649aad042";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."archetypes.referencebrowserwidget-2.4.19" self.setuptools self."zope.deprecation-3.4.1" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        ATReferenceBrowserWidget is reference widget for Archetypes.
        '';
      homepage = "http://pypi.python.org/pypi/Products.ATReferenceBrowserWidget";
      license = "GPL";
    };
  };


  "MultiMapping-2.13.0" = self.buildPythonPackage {
    name = "MultiMapping-2.13.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/M/MultiMapping/MultiMapping-2.13.0.zip";
        md5 = "d69c5904c105b9f2f085d4103e0f0586";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."ExtensionClass-2.13.2" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Special MultiMapping objects used in Zope2.
        '';
      homepage = "http://pypi.python.org/pypi/MultiMapping";
      license = "ZPL 2.1";
    };
  };


  "Products.ZSQLMethods-2.13.4" = self.buildPythonPackage {
    name = "Products.ZSQLMethods-2.13.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.ZSQLMethods/Products.ZSQLMethods-2.13.4.zip";
        md5 = "bd1ad8fd4a9d4f8b4681401dd5b71dc1";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self."ExtensionClass-2.13.2" self."Missing-2.13.1" self."Persistence-2.13.2" self."Record-2.13.0" self.setuptools self."transaction-1.1.1" self."ZODB3-3.10.5" self."zope.interface-3.6.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        SQL method support for Zope 2.
        '';
      homepage = "http://pypi.python.org/pypi/Products.ZSQLMethods";
      license = "ZPL 2.1";
    };
  };


  "plone.transformchain-1.0.3" = self.buildPythonPackage {
    name = "plone.transformchain-1.0.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.transformchain/plone.transformchain-1.0.3.zip";
        md5 = "f5fb7ca894249e3e666501c4fae52a6c";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."zope.schema-4.2.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Hook into repoze.zope2 that allows third party packages to register a sequence of hooks that will be allowed to modify the response before it is returned to the browser
        '';
      homepage = "http://pypi.python.org/pypi/plone.transformchain";
      license = "BSD";
    };
  };


  "plone.recipe.zope2instance" = self."plone.recipe.zope2instance-4.2.13";

  "plone.recipe.zope2instance-4.2.13" = self.buildPythonPackage {
    name = "plone.recipe.zope2instance-4.2.13";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.recipe.zope2instance/plone.recipe.zope2instance-4.2.13.zip";
        md5 = "1ff990a15e77a92a7339b5092bfb9cc3";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."mailinglogger-3.7.0" self.setuptools self."zc.buildout-1.7.1" self."zc.recipe.egg-1.3.2" self."ZODB3-3.10.5" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Buildout recipe for creating a Zope 2 instance
        '';
      homepage = "http://pypi.python.org/pypi/plone.recipe.zope2instance";
      license = "ZPL 2.1";
    };
  };


  "Products.CMFQuickInstallerTool-3.0.6" = self.buildPythonPackage {
    name = "Products.CMFQuickInstallerTool-3.0.6";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.CMFQuickInstallerTool/Products.CMFQuickInstallerTool-3.0.6.tar.gz";
        md5 = "af34adb87ddf2b6da48eff8b70ca2989";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self."Products.CMFCore-2.2.7" self."Products.GenericSetup-1.7.4" self.setuptools self."zope.annotation-3.5.0" self."zope.component__zcml-3.9.5" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."Zope2-2.13.21" self."eggtestinfo-0.3" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        CMFQuickInstallerTool is a facility for comfortable activation/deactivation of CMF compliant products.
        '';
      homepage = "http://pypi.python.org/pypi/Products.CMFQuickInstallerTool";
      license = "GPL";
    };
  };


  "zope.deprecation-4.0.2" = self.buildPythonPackage {
    name = "zope.deprecation-4.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.deprecation/zope.deprecation-4.0.2.tar.gz";
        md5 = "5f8cecce85f2783f9e020f1288e908fd";
    };
    doCheck = true;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope Deprecation Infrastructure
        '';
      homepage = "http://pypi.python.org/pypi/zope.deprecation";
      license = "ZPL 2.1";
    };
  };


  "Products.CMFEditions-2.2.8" = self.buildPythonPackage {
    name = "Products.CMFEditions-2.2.8";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.CMFEditions/Products.CMFEditions-2.2.8.zip";
        md5 = "1806f2e17e2527fad9364670b343bd11";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self."Products.CMFCore-2.2.7" self."Products.CMFDiffTool-2.1" self."Products.CMFUid-2.2.1" self."Products.GenericSetup-1.7.4" self."Products.ZopeVersionControl-1.1.3" self.setuptools self."transaction-1.1.1" self."ZODB3-3.10.5" self."zope.copy-3.5.0" self."zope.dottedname-3.4.6" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Versioning for Plone
        '';
      homepage = "http://pypi.python.org/pypi/Products.CMFEditions";
      license = "GPL";
    };
  };


  "plone.app.form-2.2.3" = self.buildPythonPackage {
    name = "plone.app.form-2.2.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.form/plone.app.form-2.2.3.zip";
        md5 = "4b7dcabcda1407a40185782a4d1f9a01";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self."five.formlib-1.0.4" self."plone.app.vocabularies-2.1.11" self."plone.locking-2.0.4" self."Products.CMFCore-2.2.7" self."Products.CMFDefault-2.2.3" self.setuptools self."zope.browser-1.3" self."zope.component__zcml-3.9.5" self."zope.event-3.5.2" self."zope.formlib-4.0.6" self."zope.i18n__zcml-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.schema-4.2.2" self."zope.site-3.9.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        zope.formlib integration for Plone
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.form";
      license = "GPL version 2";
    };
  };


  "Products.CMFDefault-2.2.3" = self.buildPythonPackage {
    name = "Products.CMFDefault-2.2.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.CMFDefault/Products.CMFDefault-2.2.3.tar.gz";
        md5 = "fe7d2d3906ee0e3b484e4a02401576ab";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."five.formlib-1.0.4" self."Products.CMFCore-2.2.7" self."Products.GenericSetup-1.7.4" self.setuptools self."Zope2-2.13.21" self."eggtestinfo-0.3" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Default product for the Zope Content Management Framework
        '';
      homepage = "http://pypi.python.org/pypi/Products.CMFDefault";
      license = "ZPL 2.1 (http://www.zope.org/Resources/License/ZPL-2.1)";
    };
  };


  "zope.processlifetime-1.0" = self.buildPythonPackage {
    name = "zope.processlifetime-1.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.processlifetime/zope.processlifetime-1.0.tar.gz";
        md5 = "69604bfd668a01ebebdd616a8f26ccfe";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope process lifetime events
        '';
      homepage = "http://pypi.python.org/pypi/zope.processlifetime";
      license = "ZPL 2.1";
    };
  };


  "zope.component-4.1.0" = self.buildPythonPackage {
    name = "zope.component-4.1.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.component/zope.component-4.1.0.zip";
        md5 = "8e185893699f9fa577bd9ada0a5302fa";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.event-4.0.2" self."zope.interface-4.0.5" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope Component Architecture
        '';
      homepage = "http://pypi.python.org/pypi/zope.component";
      license = "ZPL 2.1";
    };
  };


  "plone.synchronize-1.0.1" = self.buildPythonPackage {
    name = "plone.synchronize-1.0.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.synchronize/plone.synchronize-1.0.1.zip";
        md5 = "d25e86ace8daa0816861296c3288c4fb";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Simple decorators to support synchronized methods
        '';
      homepage = "http://pypi.python.org/pypi/plone.synchronize";
      license = "BSD";
    };
  };


  "collective.monkeypatcher-1.0.1" = self.buildPythonPackage {
    name = "collective.monkeypatcher-1.0.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/c/collective.monkeypatcher/collective.monkeypatcher-1.0.1.zip";
        md5 = "4d4f20f9b8bb84b24afadc4f56f6dc2c";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Support for applying monkey patches late in the startup cycle by using ZCML configuration actions
        '';
      homepage = "http://pypi.python.org/pypi/collective.monkeypatcher";
      license = "BSD";
    };
  };


  "plone.stringinterp-1.0.10" = self.buildPythonPackage {
    name = "plone.stringinterp-1.0.10";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.stringinterp/plone.stringinterp-1.0.10.zip";
        md5 = "595074e94944ad6860e2105a020a3b9a";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Products.CMFCore-2.2.7" self.setuptools self."zope.i18n__zcml-3.7.4" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Adaptable string interpolation
        '';
      homepage = "http://pypi.python.org/pypi/plone.stringinterp";
      license = "GPL version 2";
    };
  };


  "plonetheme.sunburst-1.4.5" = self.buildPythonPackage {
    name = "plonetheme.sunburst-1.4.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plonetheme.sunburst/plonetheme.sunburst-1.4.5.zip";
        md5 = "a8438d6f4a27ad6c10dc3554a9145705";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        The default theme for Plone 4.
        '';
      homepage = "http://pypi.python.org/pypi/plonetheme.sunburst";
      license = "GPL version 2";
    };
  };


  "PasteDeploy-1.5.0" = self.buildPythonPackage {
    name = "PasteDeploy-1.5.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/PasteDeploy/PasteDeploy-1.5.0.tar.gz";
        md5 = "f1a068a0b680493b6eaff3dd7690690f";
    };
    doCheck = true;
    buildInputs = [ self."nose-1.3.0" ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Load, configure, and compose WSGI applications and servers
        '';
      homepage = "http://pythonpaste.org/deploy/";
      license = "MIT";
    };
  };


  "zope.sequencesort-3.4.0" = self.buildPythonPackage {
    name = "zope.sequencesort-3.4.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.sequencesort/zope.sequencesort-3.4.0.tar.gz";
        md5 = "cfc35fc426a47f5c0ee43c416224b864";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Sequence Sorting
        '';
      homepage = "http://cheeseshop.python.org/pypi/zope.sequencesort";
      license = "ZPL 2.1";
    };
  };


  "plone.openid-2.0.1" = self.buildPythonPackage {
    name = "plone.openid-2.0.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.openid/plone.openid-2.0.1.zip";
        md5 = "d4c36926a6dbefed035ed92c29329ce1";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."Products.PluggableAuthService-1.10.0" self."python-openid-2.2.5" self.setuptools self."transaction-1.1.1" self."ZODB3-3.10.5" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        OpenID authentication support for PAS
        '';
      homepage = "http://svn.plone.org/svn/plone/plone.openid";
      license = "BSD";
    };
  };


  "plone.resourceeditor-1.0" = self.buildPythonPackage {
    name = "plone.resourceeditor-1.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.resourceeditor/plone.resourceeditor-1.0.zip";
        md5 = "443ff0a0ad83b94fc08cac46ee3b2ad4";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.resource-1.0.2" self.setuptools self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        UNKNOWN
        '';
      homepage = "https://github.com/plone/plone.resourceeditor";
      license = "GPL";
    };
  };


  "zope.app.publication-3.12.0" = self.buildPythonPackage {
    name = "zope.app.publication-3.12.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.app.publication/zope.app.publication-3.12.0.zip";
        md5 = "d8c521287f52fb9f40fa9b8c2acb4675";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."ZODB3-3.10.5" self."zope.authentication-3.7.1" self."zope.browser-1.3" self."zope.component__zcml-3.9.5" self."zope.error-3.7.4" self."zope.interface-3.6.7" self."zope.location-3.9.1" self."zope.publisher-3.12.6" self."zope.traversing-3.13.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Zope publication
        '';
      homepage = "http://pypi.python.org/pypi/zope.app.publication";
      license = "ZPL 2.1";
    };
  };


  "zope.schema-4.2.2" = self.buildPythonPackage {
    name = "zope.schema-4.2.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.schema/zope.schema-4.2.2.tar.gz";
        md5 = "e7e581af8193551831560a736a53cf58";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.event-3.5.2" self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        zope.interface extension for defining data schemas
        '';
      homepage = "http://pypi.python.org/pypi/zope.schema";
      license = "ZPL 2.1";
    };
  };


  "plone.app.content-2.1.3" = self.buildPythonPackage {
    name = "plone.app.content-2.1.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.content/plone.app.content-2.1.3.zip";
        md5 = "3463a245414518f058fa6d658a6b9caf";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."plone.batching-1.0" self."plone.i18n-2.0.9" self."plone.memoize-1.1.1" self."Products.CMFCore-2.2.7" self."Products.CMFDefault-2.2.3" self.setuptools self."zope.component__zcml-3.9.5" self."zope.container-3.11.2" self."zope.event-3.5.2" self."zope.i18n__zcml-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.viewlet-3.7.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Content Views for Plone
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.content";
      license = "GPL version 2";
    };
  };


  "Products.CMFDiffTool-2.1" = self.buildPythonPackage {
    name = "Products.CMFDiffTool-2.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.CMFDiffTool/Products.CMFDiffTool-2.1.zip";
        md5 = "7513d954294e9f318182f9d61660abdb";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."Products.CMFCore-2.2.7" self."Products.GenericSetup-1.7.4" self.setuptools self."zope.interface-3.6.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Diff tool for Plone
        '';
      homepage = "http://pypi.python.org/pypi/Products.CMFDiffTool";
      license = "GPL";
    };
  };


  "repoze.lru-0.6" = self.buildPythonPackage {
    name = "repoze.lru-0.6";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/r/repoze.lru/repoze.lru-0.6.tar.gz";
        md5 = "2c3b64b17a8e18b405f55d46173e14dd";
    };
    doCheck = true;
    buildInputs = [ self."nose-1.3.0" ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        A tiny LRU cache implementation and decorator
        '';
      homepage = "http://www.repoze.org";
      license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
    };
  };


  "Markdown-2.0.3" = self.buildPythonPackage {
    name = "Markdown-2.0.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/M/Markdown/Markdown-2.0.3.tar.gz";
        md5 = "751e8055be2433dfd1a82e0fb1b12f13";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Python implementation of Markdown.
        '';
      homepage = "http://www.freewisdom.org/projects/python-markdown";
      license = "BSD License";
    };
  };


  "plone.dexterity-2.1.3" = self.buildPythonPackage {
    name = "plone.dexterity-2.1.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.dexterity/plone.dexterity-2.1.3.zip";
        md5 = "7f6444a2c26488e4068217266fd243b7";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.alterego-1.0" self."plone.autoform-1.5" self."plone.behavior-1.0.2" self."plone.folder-1.0.4" self."plone.memoize-1.1.1" self."plone.rfc822-1.1" self."plone.supermodel-1.2.3" self."plone.synchronize-1.0.1" self."plone.uuid-1.0.3" self."plone.z3cform-0.8.0" self."Products.CMFCore-2.2.7" self."Products.CMFDefault-2.2.3" self."Products.CMFDynamicViewFTI-4.0.5" self."Products.statusmessages-4.0" self.setuptools self."ZODB3-3.10.5" self."zope.annotation-3.5.0" self."zope.browser-1.3" self."zope.component__zcml-3.9.5" self."zope.container-3.11.2" self."zope.dottedname-3.4.6" self."zope.filerepresentation-3.6.1" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.location-3.9.1" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.security__untrustedpython-3.7.4" self."zope.size-3.4.1" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Flexible CMF content
        '';
      homepage = "http://code.google.com/p/dexterity";
      license = "GPL version 2";
    };
  };


  "plone.behavior-1.0.2" = self.buildPythonPackage {
    name = "plone.behavior-1.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.behavior/plone.behavior-1.0.2.zip";
        md5 = "4459b91287ebc2f2cf4fa38728b2a739";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.annotation-3.5.0" self."zope.component__zcml-3.9.5" self."zope.configuration-3.7.4" self."zope.interface-3.6.7" self."zope.schema-4.2.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Infrastructure for maintaining a registry of available behaviors
        '';
      homepage = "http://code.google.com/p/dexterity";
      license = "BSD";
    };
  };


  "diazo-1.0.4" = self.buildPythonPackage {
    name = "diazo-1.0.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/d/diazo/diazo-1.0.4.zip";
        md5 = "b5f07cfd928e06bcb964b3f830767bab";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."experimental.cssselect-0.3" self."lxml-2.3.6" self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Diazo implements a Deliverance like language using a pure
        XSLT engine. With Diazo, you "compile" your theme and ruleset in one
        step, then use a superfast/simple transform on each request thereafter.
        Alternatively, compile your theme during development, check it into
        Subversion, and not touch Diazo during deployment.
        '';
      homepage = "http://diazo.org";
      license = "New BSD";
    };
  };


  "zc.lockfile-1.0.2" = self.buildPythonPackage {
    name = "zc.lockfile-1.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zc.lockfile/zc.lockfile-1.0.2.tar.gz";
        md5 = "f099d4cf2583a0c7bea0146a44dc4d59";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Basic inter-process locks
        '';
      homepage = "http://www.python.org/pypi/zc.lockfile";
      license = "ZPL 2.1";
    };
  };


  "zope.tales-3.5.3" = self.buildPythonPackage {
    name = "zope.tales-3.5.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.tales/zope.tales-3.5.3.tar.gz";
        md5 = "a2dbc6e41140c29de81b66a4d703fc3f";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.interface-3.6.7" self."zope.tal-3.5.2" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope Template Application Language Expression Syntax (TALES)
        '';
      homepage = "http://pypi.python.org/pypi/zope.tales";
      license = "ZPL 2.1";
    };
  };


  "DateTime-3.0.3" = self.buildPythonPackage {
    name = "DateTime-3.0.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/D/DateTime/DateTime-3.0.3.zip";
        md5 = "5ebf0a8e3775b744c5de2e6685b37ae9";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."pytz-2013b" self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        This package provides a DateTime data type, as known from Zope 2.Unless you need to communicate with Zope 2 APIs, you're probablybetter off using Python's built-in datetime module.
        '';
      homepage = "http://pypi.python.org/pypi/DateTime";
      license = "ZPL 2.1";
    };
  };


  "z3c.autoinclude-0.3.4" = self.buildPythonPackage {
    name = "z3c.autoinclude-0.3.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/z3c.autoinclude/z3c.autoinclude-0.3.4.zip";
        md5 = "6a615ae18c12b459bceb3ae28e8e7709";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zc.buildout-1.7.1" self."zope.configuration-3.7.4" self."zope.dottedname-3.4.6" self."zope.interface-3.6.7" self."zope.schema-4.2.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Automatically include ZCML
        '';
      homepage = "UNKNOWN";
      license = "ZPL";
    };
  };


  "pytz-2013b" = self.buildPythonPackage {
    name = "pytz-2013b";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/pytz/pytz-2013b.tar.bz2";
        md5 = "34f47470eedd5cd1faf6c3da2741967b";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        World timezone definitions, modern and historical
        '';
      homepage = "http://pytz.sourceforge.net";
      license = "MIT";
    };
  };


  "zope.configuration-3.7.4" = self.buildPythonPackage {
    name = "zope.configuration-3.7.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.configuration/zope.configuration-3.7.4.zip";
        md5 = "5b0271908ef26c05059eda76928896ea";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.schema-4.2.2" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope Configuration Markup Language (ZCML)
        '';
      homepage = "http://pypi.python.org/pypi/zope.configuration";
      license = "ZPL 2.1";
    };
  };


  "plone.app.iterate-2.1.10" = self.buildPythonPackage {
    name = "plone.app.iterate-2.1.10";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.iterate/plone.app.iterate-2.1.10.zip";
        md5 = "8bd270d8a3c9509e524a06e092a9b4c4";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self."plone.locking-2.0.4" self."plone.memoize-1.1.1" self."Products.Archetypes-1.9.4" self."Products.CMFCore-2.2.7" self."Products.CMFEditions-2.2.8" self."Products.CMFPlacefulWorkflow-1.5.9" self."Products.DCWorkflow-2.2.4" self."Products.statusmessages-4.0" self.setuptools self."ZODB3-3.10.5" self."zope.annotation-3.5.0" self."zope.component__zcml-3.9.5" self."zope.event-3.5.2" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.schema-4.2.2" self."zope.viewlet-3.7.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        check-out/check-in staging for Plone
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.iterate";
      license = "GPL version 2";
    };
  };


  "python-openid-2.2.5" = self.buildPythonPackage {
    name = "python-openid-2.2.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/python-openid/python-openid-2.2.5.tar.gz";
        md5 = "393f48b162ec29c3de9e2973548ea50d";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        OpenID support for servers and consumers.
        '';
      homepage = "http://github.com/openid/python-openid";
      license = "UNKNOWN";
    };
  };


  "Products.MailHost-2.13.1" = self.buildPythonPackage {
    name = "Products.MailHost-2.13.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.MailHost/Products.MailHost-2.13.1.zip";
        md5 = "1102e523435d8bf78a15b9ddb57478e1";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        zope.sendmail integration for Zope 2.
        '';
      homepage = "http://pypi.python.org/pypi/Products.MailHost";
      license = "ZPL 2.1";
    };
  };


  "zope.broken-3.6.0" = self.buildPythonPackage {
    name = "zope.broken-3.6.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.broken/zope.broken-3.6.0.zip";
        md5 = "eff24d7918099a3e899ee63a9c31bee6";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope Broken Object Interfaces
        '';
      homepage = "http://pypi.python.org/pypi/zope.broken";
      license = "ZPL 2.1";
    };
  };


  "lxml-3.2.3" = self.buildPythonPackage {
    name = "lxml-3.2.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/l/lxml/lxml-3.2.3.tar.gz";
        md5 = "fef47bb4ac72ac38ce778518dac42236";
    };
    doCheck = false;
    buildInputs = [ pkgs.libxml2 pkgs.libxslt ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Powerful and Pythonic XML processing library combining libxml2/libxslt with the ElementTree API.
        '';
      homepage = "http://lxml.de/";
      license = "UNKNOWN";
    };
  };


  "Products.PythonScripts-2.13.2" = self.buildPythonPackage {
    name = "Products.PythonScripts-2.13.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.PythonScripts/Products.PythonScripts-2.13.2.zip";
        md5 = "04c86f2c45a29a162297a80dac61d14f";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."AccessControl-3.0.8" self."Acquisition-2.13.8" self."DateTime-3.0.3" self."DocumentTemplate-2.13.2" self."RestrictedPython-3.6.0" self.setuptools self."zExceptions-2.13.0" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Provides support for restricted execution of Python scripts in Zope 2.
        '';
      homepage = "http://pypi.python.org/pypi/Products.PythonScripts";
      license = "ZPL 2.1";
    };
  };


  "plone.app.controlpanel-2.3.7" = self.buildPythonPackage {
    name = "plone.app.controlpanel-2.3.7";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.controlpanel/plone.app.controlpanel-2.3.7.zip";
        md5 = "537072fe22237a2148310b8714755356";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."plone.app.form-2.2.3" self."plone.app.vocabularies-2.1.11" self."plone.app.workflow-2.1.6" self."plone.fieldsets-2.0.2" self."plone.locking-2.0.4" self."plone.memoize-1.1.1" self."plone.protect-2.0.2" self."Products.CMFCore-2.2.7" self."Products.CMFDefault-2.2.3" self."Products.PlonePAS-4.1.1" self."Products.PortalTransforms-2.1.2" self."Products.statusmessages-4.0" self.setuptools self."ZODB3-3.10.5" self."zope.annotation-3.5.0" self."zope.cachedescriptors-3.5.1" self."zope.component__zcml-3.9.5" self."zope.event-3.5.2" self."zope.formlib-4.0.6" self."zope.i18n__zcml-3.7.4" self."zope.interface-3.6.7" self."zope.publisher-3.12.6" self."zope.ramcache-1.0" self."zope.schema-4.2.2" self."zope.site-3.9.2" self."zope.testing-3.9.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Formlib-based controlpanels for Plone.
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.controlpanel";
      license = "GPL version 2";
    };
  };


  "zope.ptresource-3.9.0" = self.buildPythonPackage {
    name = "zope.ptresource-3.9.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.ptresource/zope.ptresource-3.9.0.tar.gz";
        md5 = "f4645e51c15289d3fdfb4139039e18e9";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.browserresource-3.10.3" self."zope.interface-3.6.7" self."zope.pagetemplate-3.6.3" self."zope.publisher-3.12.6" self."zope.security__untrustedpython-3.7.4" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Page template resource plugin for zope.browserresource
        '';
      homepage = "http://pypi.python.org/pypi/zope.ptresource/";
      license = "UNKNOWN";
    };
  };


  "docutils-0.9.1" = self.buildPythonPackage {
    name = "docutils-0.9.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/d/docutils/docutils-0.9.1.tar.gz";
        md5 = "b0d5cd5298fedf9c62f5fd364a274d56";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Docutils -- Python Documentation Utilities
        '';
      homepage = "http://docutils.sourceforge.net/";
      license = "public domain, Python, 2-Clause BSD, GPL 3 (see COPYING.txt)";
    };
  };


  "beautifulsoup4-4.3.2" = self.buildPythonPackage {
    name = "beautifulsoup4-4.3.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/b/beautifulsoup4/beautifulsoup4-4.3.2.tar.gz";
        md5 = "b8d157a204d56512a4cc196e53e7d8ee";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Screen-scraping library
        '';
      homepage = "http://www.crummy.com/software/BeautifulSoup/bs4/";
      license = "MIT";
    };
  };


  "Products.PloneLanguageTool-3.2.7" = self.buildPythonPackage {
    name = "Products.PloneLanguageTool-3.2.7";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.PloneLanguageTool/Products.PloneLanguageTool-3.2.7.zip";
        md5 = "bd9eb6278bf76e8cbce99437ca362164";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        PloneLanguageTool allows you to set the available languages in your Plone site, select various fallback mechanisms, and control the use of flags for language selection and translations.
        '';
      homepage = "http://pypi.python.org/pypi/Products.PloneLanguageTool";
      license = "GPL";
    };
  };


  "nose-1.3.0" = self.buildPythonPackage {
    name = "nose-1.3.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/n/nose/nose-1.3.0.tar.gz";
        md5 = "95d6d32b9d6b029c3c65674bd9e7eabe";
    };
    doCheck = true;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        nose extends unittest to make testing easier
        '';
      homepage = "http://readthedocs.org/docs/nose/";
      license = "GNU LGPL";
    };
  };


  "zope.error-3.7.4" = self.buildPythonPackage {
    name = "zope.error-3.7.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.error/zope.error-3.7.4.tar.gz";
        md5 = "281445a906458ff5f18f56923699a127";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."ZODB3-3.10.5" self."zope.exceptions-3.6.2" self."zope.interface-3.6.7" self."zope.location-3.9.1" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        An error reporting utility for Zope3
        '';
      homepage = "http://pypi.python.org/pypi/zope.error";
      license = "ZPL 2.1";
    };
  };


  "plone.app.openid-2.0.2" = self.buildPythonPackage {
    name = "plone.app.openid-2.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.openid/plone.app.openid-2.0.2.tar.gz";
        md5 = "ae0748f91cab0612a498926d405d8edd";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."plone.app.portlets-2.4.5" self."plone.openid-2.0.1" self."plone.portlets-2.2" self."Products.CMFCore-2.2.7" self."Products.PlonePAS-4.1.1" self."Products.PluggableAuthService-1.10.0" self.setuptools self."zope.component__zcml-3.9.5" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Plone OpenID authentication support
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.openid";
      license = "GPL version 2";
    };
  };


  "Products.PortalTransforms-2.1.2" = self.buildPythonPackage {
    name = "Products.PortalTransforms-2.1.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.PortalTransforms/Products.PortalTransforms-2.1.2.zip";
        md5 = "9f429f3c3b9e0019d0f6c9b7a8a9376e";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."Markdown-2.0.3" self."plone.intelligenttext-2.0.2" self."Products.CMFCore-2.2.7" self."Products.CMFDefault-2.2.3" self."Products.MimetypesRegistry-2.0.5" self.setuptools self."ZODB3-3.10.5" self."zope.interface-3.6.7" self."zope.structuredtext-3.5.1" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        MIME based content transformations
        '';
      homepage = "http://pypi.python.org/pypi/Products.PortalTransforms";
      license = "UNKNOWN";
    };
  };


  "zope.schema-4.3.2" = self.buildPythonPackage {
    name = "zope.schema-4.3.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.schema/zope.schema-4.3.2.zip";
        md5 = "b63df4a3035f29113f8130c8ae28bb13";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.event-4.0.2" self."zope.interface-4.0.5" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        zope.interface extension for defining data schemas
        '';
      homepage = "http://pypi.python.org/pypi/zope.schema";
      license = "ZPL 2.1";
    };
  };


  "plone.keyring-2.0.1" = self.buildPythonPackage {
    name = "plone.keyring-2.0.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.keyring/plone.keyring-2.0.1.zip";
        md5 = "f3970e9bddb2cc65e461a2c62879233f";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."ZODB3-3.10.5" self."zope.container-3.11.2" self."zope.interface-3.6.7" self."zope.location-3.9.1" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Manage secrets
        '';
      homepage = "http://pypi.python.org/pypi/plone.keyring";
      license = "BSD";
    };
  };


  "plone.app.portlets-2.4.5" = self.buildPythonPackage {
    name = "plone.app.portlets-2.4.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.portlets/plone.app.portlets-2.4.5.zip";
        md5 = "409aeeed42d87af8338197514363ec76";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self."feedparser-5.0.1" self."five.customerize-1.1" self."five.formlib-1.0.4" self."plone.app.form-2.2.3" self."plone.app.i18n-2.0.2" self."plone.app.vocabularies-2.1.11" self."plone.i18n-2.0.9" self."plone.memoize-1.1.1" self."plone.portlets-2.2" self."Products.CMFCore-2.2.7" self."Products.CMFDynamicViewFTI-4.0.5" self."Products.GenericSetup-1.7.4" self."Products.PluggableAuthService-1.10.0" self.setuptools self."transaction-1.1.1" self."ZODB3-3.10.5" self."zope.annotation-3.5.0" self."zope.browser-1.3" self."zope.component__zcml-3.9.5" self."zope.configuration-3.7.4" self."zope.container-3.11.2" self."zope.contentprovider-3.7.2" self."zope.event-3.5.2" self."zope.formlib-4.0.6" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.site-3.9.2" self."zope.traversing-3.13.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Plone integration for the basic plone.portlets package
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.portlets";
      license = "GPL version 2";
    };
  };


  "Plone" = self."Plone-4.3.2";

  "Plone-4.3.2" = self.buildPythonPackage {
    name = "Plone-4.3.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Plone/Plone-4.3.2.zip";
        md5 = "809f9fe8b8d23b49778e8ce304ea34f6";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.app.caching-1.1.6" self."plone.app.dexterity-2.0.9" self."plone.app.iterate-2.1.10" self."plone.app.openid-2.0.2" self."plone.app.theming-1.1.1" self."Products.CMFPlacefulWorkflow-1.5.9" self."Products.CMFPlone-4.3.2" self.setuptools self."wicked-1.1.10" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        The Plone Content Management System
        '';
      homepage = "http://plone.org/";
      license = "GPL version 2";
    };
  };


  "Persistence-2.13.2" = self.buildPythonPackage {
    name = "Persistence-2.13.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Persistence/Persistence-2.13.2.zip";
        md5 = "92693648ccdc59c8fc71f7f06b1d228c";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."ExtensionClass-2.13.2" self."ZODB3-3.10.5" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Persistent ExtensionClass
        '';
      homepage = "http://pypi.python.org/pypi/Persistence";
      license = "ZPL 2.1";
    };
  };


  "feedparser-5.0.1" = self.buildPythonPackage {
    name = "feedparser-5.0.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/f/feedparser/feedparser-5.0.1.tar.bz2";
        md5 = "702835de74bd4a578524f311e62c2877";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        
        '';
      homepage = "https://code.google.com/p/feedparser/";
      license = "";
    };
  };


  "zc.recipe.egg-1.3.2" = self.buildPythonPackage {
    name = "zc.recipe.egg-1.3.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zc.recipe.egg/zc.recipe.egg-1.3.2.tar.gz";
        md5 = "1cb6af73f527490dde461d3614a36475";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zc.buildout-1.7.1" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Recipe for installing Python package distributions as eggs
        '';
      homepage = "http://cheeseshop.python.org/pypi/zc.recipe.egg";
      license = "ZPL 2.1";
    };
  };


  "mailinglogger-3.7.0" = self.buildPythonPackage {
    name = "mailinglogger-3.7.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/m/mailinglogger/mailinglogger-3.7.0.tar.gz";
        md5 = "f865f0df6059ce23062b7457d01dbac5";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Enhanced emailing handlers for the python logging package.
        '';
      homepage = "http://www.simplistix.co.uk/software/python/mailinglogger";
      license = "MIT";
    };
  };


  "plone.app.jquerytools-1.5.6" = self.buildPythonPackage {
    name = "plone.app.jquerytools-1.5.6";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.jquerytools/plone.app.jquerytools-1.5.6.zip";
        md5 = "4ae9a72baa8e9899c1706b4fedbb516b";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Products.CMFCore-2.2.7" self."Products.GenericSetup-1.7.4" self.setuptools self."zope.component__zcml-3.9.5" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        jQuery Tools integration for Plone plus overlay and AJAX form helpers.
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.jquerytools";
      license = "GPL version 2";
    };
  };


  "Products.BTreeFolder2-2.13.3" = self.buildPythonPackage {
    name = "Products.BTreeFolder2-2.13.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.BTreeFolder2/Products.BTreeFolder2-2.13.3.tar.gz";
        md5 = "f57c85673036af7ccd34c3fa251f6bb2";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."AccessControl-3.0.8" self."Acquisition-2.13.8" self."Persistence-2.13.2" self.setuptools self."ZODB3-3.10.5" self."zope.container-3.11.2" self."zope.event-3.5.2" self."zope.lifecycleevent-3.6.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        A BTree based implementation for Zope 2's OFS.
        '';
      homepage = "http://pypi.python.org/pypi/Products.BTreeFolder2";
      license = "ZPL 2.1";
    };
  };


  "plone.locking-2.0.4" = self.buildPythonPackage {
    name = "plone.locking-2.0.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.locking/plone.locking-2.0.4.zip";
        md5 = "a7f8b8db78f57272d351d7fe0d067eb2";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self."Products.CMFCore-2.2.7" self.setuptools self."ZODB3-3.10.5" self."zope.annotation-3.5.0" self."zope.component__zcml-3.9.5" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.schema-4.2.2" self."zope.viewlet-3.7.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        webdav locking support
        '';
      homepage = "http://pypi.python.org/pypi/plone.locking";
      license = "GPL version 2";
    };
  };


  "plone.formwidget.namedfile-1.0.7" = self.buildPythonPackage {
    name = "plone.formwidget.namedfile-1.0.7";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.formwidget.namedfile/plone.formwidget.namedfile-1.0.7.zip";
        md5 = "6fa3cd99bf9b30971034b0f6dc31cfb3";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.namedfile__scales-2.0.2" self."plone.z3cform-0.8.0" self.setuptools self."z3c.form-3.0.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Image widget for z3c.form and Plone
        '';
      homepage = "http://pypi.python.org/pypi/plone.formwidget.namedfile";
      license = "GPL";
    };
  };


  "zope.testing-3.9.7" = self.buildPythonPackage {
    name = "zope.testing-3.9.7";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.testing/zope.testing-3.9.7.tar.gz";
        md5 = "8999f3d143d416dc3c8b2a5bd6f33e28";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.exceptions-3.6.2" self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope testing framework, including the testrunner script.
        '';
      homepage = "http://pypi.python.org/pypi/zope.testing";
      license = "ZPL 2.1";
    };
  };


  "zope.lifecycleevent-3.6.2" = self.buildPythonPackage {
    name = "zope.lifecycleevent-3.6.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.lifecycleevent/zope.lifecycleevent-3.6.2.tar.gz";
        md5 = "3ba978f3ba7c0805c81c2c79ea3edb33";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.component__zcml-3.9.5" self."zope.event-3.5.2" self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Object life-cycle events
        '';
      homepage = "http://pypi.python.org/pypi/zope.lifecycleevent";
      license = "ZPL 2.1";
    };
  };


  "ExtensionClass-2.13.2" = self.buildPythonPackage {
    name = "ExtensionClass-2.13.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/E/ExtensionClass/ExtensionClass-2.13.2.zip";
        md5 = "0236e6d7da9e8b87b9ba45f1b8f930b8";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Metaclass for subclassable extension types
        '';
      homepage = "http://pypi.python.org/pypi/ExtensionClass";
      license = "ZPL 2.1";
    };
  };


  "plone.app.contentrules-3.0.4" = self.buildPythonPackage {
    name = "plone.app.contentrules-3.0.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.contentrules/plone.app.contentrules-3.0.4.zip";
        md5 = "15e86e2739096bff5bf0745590d5ebb0";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."five.formlib-1.0.4" self."plone.app.form-2.2.3" self."plone.app.vocabularies-2.1.11" self."plone.contentrules-2.0.3" self."plone.memoize-1.1.1" self."plone.stringinterp-1.0.10" self."plone.uuid-1.0.3" self."Products.CMFCore-2.2.7" self."Products.CMFDefault-2.2.3" self."Products.GenericSetup-1.7.4" self."Products.statusmessages-4.0" self.setuptools self."transaction-1.1.1" self."ZODB3-3.10.5" self."zope.annotation-3.5.0" self."zope.browser-1.3" self."zope.component__zcml-3.9.5" self."zope.container-3.11.2" self."zope.event-3.5.2" self."zope.formlib-4.0.6" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.site-3.9.2" self."zope.traversing-3.13.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Plone integration for plone.contentrules
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.contentrules";
      license = "GPL version 2";
    };
  };


  "translationstring-1.1" = self.buildPythonPackage {
    name = "translationstring-1.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/t/translationstring/translationstring-1.1.tar.gz";
        md5 = "0979b46d8f0f852810c8ec4be5c26cf2";
    };
    doCheck = true;
    buildInputs = [ self."nose-1.3.0" ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Utility library for i18n relied on by various Repoze and Pyramid packages
        '';
      homepage = "http://pylonsproject.org";
      license = "BSD-like (http://repoze.org/license.html)";
    };
  };


  "MarkupSafe-0.18" = self.buildPythonPackage {
    name = "MarkupSafe-0.18";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.18.tar.gz";
        md5 = "f8d252fd05371e51dec2fe9a36890687";
    };
    doCheck = true;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Implements a XML/HTML/XHTML Markup safe string for Python
        '';
      homepage = "http://github.com/mitsuhiko/markupsafe";
      license = "BSD";
    };
  };


  "zope.pagetemplate-3.6.3" = self.buildPythonPackage {
    name = "zope.pagetemplate-3.6.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.pagetemplate/zope.pagetemplate-3.6.3.zip";
        md5 = "834a4bf702c05fba1e669677b4dc871f";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.component__zcml-3.9.5" self."zope.i18n__zcml-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.security__untrustedpython-3.7.4" self."zope.tal-3.5.2" self."zope.tales-3.5.3" self."zope.traversing-3.13.2" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope Page Templates
        '';
      homepage = "http://pypi.python.org/pypi/zope.pagetemplate";
      license = "ZPL 2.1";
    };
  };


  "python-gettext-1.2" = self.buildPythonPackage {
    name = "python-gettext-1.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/python-gettext/python-gettext-1.2.zip";
        md5 = "cd4201d440126d1296d1d2bc2b4795f3";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."unittest2-0.5.1" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Python Gettext po to mo file compiler.
        '';
      homepage = "http://pypi.python.org/pypi/python-gettext";
      license = "BSD";
    };
  };


  "zc.buildout-1.7.1" = self.buildPythonPackage {
    name = "zc.buildout-1.7.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zc.buildout/zc.buildout-1.7.1.tar.gz";
        md5 = "8834a21586bf2be53dc412002241a996";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        System for managing development buildouts
        '';
      homepage = "http://pypi.python.org/pypi/zc.buildout";
      license = "ZPL 2.1";
    };
  };


  "archetypes.schemaextender-2.1.2" = self.buildPythonPackage {
    name = "archetypes.schemaextender-2.1.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/a/archetypes.schemaextender/archetypes.schemaextender-2.1.2.zip";
        md5 = "865aa5b4b6b26e3bb650d89ddfe77c87";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.uuid-1.0.3" self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Dynamically extend Archetypes schemas with named adapters.
        '';
      homepage = "http://pypi.python.org/pypi/archetypes.schemaextender";
      license = "GPL";
    };
  };


  "zope.tal-3.5.2" = self.buildPythonPackage {
    name = "zope.tal-3.5.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.tal/zope.tal-3.5.2.zip";
        md5 = "13869f292ba36b294736b7330b1396fd";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope 3 Template Application Languate (TAL)
        '';
      homepage = "http://pypi.python.org/pypi/zope.tal";
      license = "ZPL 2.1";
    };
  };


  "Products.OFSP-2.13.2" = self.buildPythonPackage {
    name = "Products.OFSP-2.13.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.OFSP/Products.OFSP-2.13.2.zip";
        md5 = "c76d40928753c2ee56db873304e65bd5";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."AccessControl-3.0.8" self."Persistence-2.13.2" self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        General Zope 2 help screens.
        '';
      homepage = "http://pypi.python.org/pypi/Products.OFSP";
      license = "ZPL 2.1";
    };
  };


  "cssselect-0.9" = self.buildPythonPackage {
    name = "cssselect-0.9";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/c/cssselect/cssselect-0.9.tar.gz";
        md5 = "3aba1e431787da957a9cd1e2c2e0bf1c";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        cssselect parses CSS3 Selectors and translates them to XPath 1.0
        '';
      homepage = "http://packages.python.org/cssselect/";
      license = "BSD";
    };
  };


  "plone.app.search-1.1.5" = self.buildPythonPackage {
    name = "plone.app.search-1.1.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.search/plone.app.search-1.1.5.zip";
        md5 = "eeb42889464d35e9d8169e062bc9c827";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.app.contentlisting-1.0.5" self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Search user interface for Plone CMS.
        '';
      homepage = "http://github.com/plone/plone.app.search";
      license = "GPL";
    };
  };


  "zope.container-3.11.2" = self.buildPythonPackage {
    name = "zope.container-3.11.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.container/zope.container-3.11.2.tar.gz";
        md5 = "fc66d85a17b8ffb701091c9328983dcc";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."ZODB3-3.10.5" self."zope.broken-3.6.0" self."zope.component__zcml-3.9.5" self."zope.dottedname-3.4.6" self."zope.event-3.5.2" self."zope.filerepresentation-3.6.1" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.location-3.9.1" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.security__untrustedpython-3.7.4" self."zope.size-3.4.1" self."zope.traversing-3.13.2" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope Container
        '';
      homepage = "http://pypi.python.org/pypi/zope.container";
      license = "ZPL 2.1";
    };
  };


  "Products.PloneTestCase-0.9.17" = self.buildPythonPackage {
    name = "Products.PloneTestCase-0.9.17";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.PloneTestCase/Products.PloneTestCase-0.9.17.zip";
        md5 = "2a5bfb94220a520961d710abc92280f2";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."Products.ATContentTypes-2.1.13" self."Products.CMFCore-2.2.7" self."Products.CMFPlone-4.3.2" self."Products.GenericSetup-1.7.4" self.setuptools self."ZODB3-3.10.5" self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."zope.site-3.9.2" self."zope.testing-3.9.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Integration testing framework for Plone.
        '';
      homepage = "http://plone.org/products/plonetestcase";
      license = "GPL";
    };
  };


  "unittest2-0.5.1" = self.buildPythonPackage {
    name = "unittest2-0.5.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/u/unittest2/unittest2-0.5.1.tar.gz";
        md5 = "a0af5cac92bbbfa0c3b0e99571390e0f";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        The new features in unittest for Python 2.7 backported to Python 2.3+.
        '';
      homepage = "http://pypi.python.org/pypi/unittest2";
      license = "UNKNOWN";
    };
  };


  "zExceptions-2.13.0" = self.buildPythonPackage {
    name = "zExceptions-2.13.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zExceptions/zExceptions-2.13.0.zip";
        md5 = "4c679696c959040d8e656ef85ae40136";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.interface-3.6.7" self."zope.publisher-3.12.6" self."zope.security__untrustedpython-3.7.4" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        zExceptions contains common exceptions used in Zope2.
        '';
      homepage = "http://pypi.python.org/pypi/zExceptions";
      license = "ZPL 2.1";
    };
  };


  "Products.CMFDynamicViewFTI-4.0.5" = self.buildPythonPackage {
    name = "Products.CMFDynamicViewFTI-4.0.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.CMFDynamicViewFTI/Products.CMFDynamicViewFTI-4.0.5.zip";
        md5 = "2d31b1700ed8b1441adc737b454af693";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."ExtensionClass-2.13.2" self."Products.CMFCore-2.2.7" self."Products.GenericSetup-1.7.4" self.setuptools self."zope.browsermenu-3.9.1" self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        CMFDynamicViewFTI is a product for dynamic views in CMF.
        '';
      homepage = "http://pypi.python.org/pypi/Products.CMFDynamicViewFTI";
      license = "ZPL";
    };
  };


  "zope.publisher-3.12.6" = self.buildPythonPackage {
    name = "zope.publisher-3.12.6";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.publisher/zope.publisher-3.12.6.tar.gz";
        md5 = "495131970cc7cb14de8e517fb3857ade";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.browser-1.3" self."zope.component__zcml-3.9.5" self."zope.configuration-3.7.4" self."zope.contenttype-3.5.5" self."zope.event-3.5.2" self."zope.exceptions-3.6.2" self."zope.i18n__zcml-3.7.4" self."zope.interface-3.6.7" self."zope.location-3.9.1" self."zope.proxy-3.6.1" self."zope.security__untrustedpython-3.7.4" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        The Zope publisher publishes Python objects on the web.
        '';
      homepage = "http://pypi.python.org/pypi/zope.publisher";
      license = "ZPL 2.1";
    };
  };


  "Products.ExternalEditor-1.1.0" = self.buildPythonPackage {
    name = "Products.ExternalEditor-1.1.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.ExternalEditor/Products.ExternalEditor-1.1.0.zip";
        md5 = "475fea6e0b958c0c51cfdbfef2f4e623";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Zope External Editor
        '';
      homepage = "http://pypi.python.org/pypi/Products.ExternalEditor";
      license = "ZPL 2.1";
    };
  };


  "plone.app.i18n-2.0.2" = self.buildPythonPackage {
    name = "plone.app.i18n-2.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.i18n/plone.app.i18n-2.0.2.zip";
        md5 = "a10026573463dfc1899bf4062cebdbf2";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Plone specific i18n extensions.
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.i18n";
      license = "GPL version 2";
    };
  };


  "zope.security__untrustedpython-3.7.4" = self.buildPythonPackage {
    name = "zope.security__untrustedpython-3.7.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.security/zope.security-3.7.4.tar.gz";
        md5 = "072ab8d11adc083eace11262da08630c";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.component__zcml-3.9.5" self."zope.configuration-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.location-3.9.1" self."zope.proxy-3.6.1" self."zope.schema-4.2.2" self."RestrictedPython-3.6.0" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope Security Framework
        '';
      homepage = "http://pypi.python.org/pypi/zope.security";
      license = "ZPL 2.1";
    };
  };


  "plone.cachepurging-1.0.4" = self.buildPythonPackage {
    name = "plone.cachepurging-1.0.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.cachepurging/plone.cachepurging-1.0.4.zip";
        md5 = "886814ac4deef0f1ed99a2eb60864264";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."five.globalrequest-1.0" self."plone.registry-1.0.1" self.setuptools self."zope.annotation-3.5.0" self."zope.component__zcml-3.9.5" self."zope.event-3.5.2" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Cache purging support for Zope 2 applications
        '';
      homepage = "http://pypi.python.org/pypi/plone.cachepurging";
      license = "GPL version 2";
    };
  };


  "roman-1.4.0" = self.buildPythonPackage {
    name = "roman-1.4.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/r/roman/roman-1.4.0.tar.gz";
        md5 = "4f8832ed4108174b159c2afb4bd1d1dd";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Integer to Roman numerals converter
        '';
      homepage = "http://pypi.python.org/pypi/roman";
      license = "Python 2.1.1";
    };
  };


  "zope.component__zcml-3.9.5" = self.buildPythonPackage {
    name = "zope.component__zcml-3.9.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.component/zope.component-3.9.5.tar.gz";
        md5 = "22780b445b1b479701c05978055d1c82";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.event-3.5.2" self."zope.interface-3.6.7" self."zope.configuration-3.7.4" self."zope.i18nmessageid-3.5.3" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope Component Architecture
        '';
      homepage = "http://pypi.python.org/pypi/zope.component";
      license = "ZPL 2.1";
    };
  };


  "psycopg2" = self."psycopg2-2.5.1";

  "psycopg2-2.5.1" = self.buildPythonPackage {
    name = "psycopg2-2.5.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/psycopg2/psycopg2-2.5.1.tar.gz";
        md5 = "1b433f83d50d1bc61e09026e906d84c7";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Python-PostgreSQL Database Adapter
        '';
      homepage = "http://initd.org/psycopg/";
      license = "GPL with exceptions or ZPL";
    };
  };


  "plone.rfc822-1.1" = self.buildPythonPackage {
    name = "plone.rfc822-1.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.rfc822/plone.rfc822-1.1.zip";
        md5 = "ba3e26cab9e751fb1cf40639d661d2f0";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."python-dateutil-1.5" self.setuptools self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."zope.schema-4.2.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        RFC822 marshalling for zope.schema fields
        '';
      homepage = "http://pypi.python.org/pypi/plone.rfc822";
      license = "BSD";
    };
  };


  "zope.viewlet-3.7.2" = self.buildPythonPackage {
    name = "zope.viewlet-3.7.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.viewlet/zope.viewlet-3.7.2.tar.gz";
        md5 = "367e03096df57e2f9b74fff43f7901f9";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.browserpage-3.12.2" self."zope.component__zcml-3.9.5" self."zope.configuration-3.7.4" self."zope.contentprovider-3.7.2" self."zope.event-3.5.2" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.location-3.9.1" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.security__untrustedpython-3.7.4" self."zope.traversing-3.13.2" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope Viewlets
        '';
      homepage = "http://pypi.python.org/pypi/zope.viewlet";
      license = "ZPL 2.1";
    };
  };


  "zope.i18n__zcml-3.7.4" = self.buildPythonPackage {
    name = "zope.i18n__zcml-3.7.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.i18n/zope.i18n-3.7.4.tar.gz";
        md5 = "a6fe9d9ad53dd7e94e87cd58fb67d3b7";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."pytz-2013b" self.setuptools self."zope.component__zcml-3.9.5" self."zope.i18nmessageid-3.5.3" self."zope.schema-4.2.2" self."zope.configuration-3.7.4" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope Internationalization Support
        '';
      homepage = "http://pypi.python.org/pypi/zope.i18n";
      license = "ZPL 2.1";
    };
  };


  "Products.ATContentTypes-2.1.13" = self.buildPythonPackage {
    name = "Products.ATContentTypes-2.1.13";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.ATContentTypes/Products.ATContentTypes-2.1.13.zip";
        md5 = "093899fc74f5e2a83db464c96d0f5293";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."archetypes.referencebrowserwidget-2.4.19" self."DateTime-3.0.3" self."ExtensionClass-2.13.2" self."plone.app.folder-1.0.5" self."plone.app.layout-2.3.7" self."plone.i18n-2.0.9" self."plone.memoize-1.1.1" self."Products.Archetypes-1.9.4" self."Products.ATReferenceBrowserWidget-3.0" self."Products.CMFCore-2.2.7" self."Products.CMFDefault-2.2.3" self."Products.CMFDynamicViewFTI-4.0.5" self."Products.GenericSetup-1.7.4" self."Products.MimetypesRegistry-2.0.5" self."Products.PortalTransforms-2.1.2" self."Products.validation-2.0" self.setuptools self."transaction-1.1.1" self."ZConfig-2.9.1" self."ZODB3-3.10.5" self."zope.component__zcml-3.9.5" self."zope.i18n__zcml-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.publisher-3.12.6" self."zope.tal-3.5.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Default Content Types for Plone
        '';
      homepage = "http://plone.org/";
      license = "GPL";
    };
  };


  "WSGIProxy2-0.3" = self.buildPythonPackage {
    name = "WSGIProxy2-0.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/W/WSGIProxy2/WSGIProxy2-0.3.zip";
        md5 = "8b2cb207932eb8c341c3fa41f0cbe994";
    };
    doCheck = true;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."six-1.4.1" self."WebOb-1.2.3" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        UNKNOWN
        '';
      homepage = "https://github.com/gawel/WSGIProxy2/";
      license = "MIT";
    };
  };


  "zope.browserresource-3.10.3" = self.buildPythonPackage {
    name = "zope.browserresource-3.10.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.browserresource/zope.browserresource-3.10.3.zip";
        md5 = "dbfde30e82dbfa1a74c5da0cb5a4772d";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.component__zcml-3.9.5" self."zope.configuration-3.7.4" self."zope.contenttype-3.5.5" self."zope.i18n__zcml-3.7.4" self."zope.interface-3.6.7" self."zope.location-3.9.1" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.traversing-3.13.2" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Browser resources implementation for Zope.
        '';
      homepage = "http://pypi.python.org/pypi/zope.browserresource/";
      license = "UNKNOWN";
    };
  };


  "RelStorage" = self."RelStorage-1.5.1";

  "RelStorage-1.5.1" = self.buildPythonPackage {
    name = "RelStorage-1.5.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/R/RelStorage/RelStorage-1.5.1.tar.gz";
        md5 = "2454211d086ac02a4af10f7292e260ec";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."zc.lockfile-1.0.2" self."ZODB3-3.10.5" self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        A backend for ZODB that stores pickles in a relational database.
        '';
      homepage = "http://pypi.python.org/pypi/RelStorage";
      license = "ZPL 2.1";
    };
  };


  "Products.ResourceRegistries-2.2.9" = self.buildPythonPackage {
    name = "Products.ResourceRegistries-2.2.9";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.ResourceRegistries/Products.ResourceRegistries-2.2.9.zip";
        md5 = "8dd4f36eb894d868366b51941f6f0966";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self."Products.CMFCore-2.2.7" self."Products.GenericSetup-1.7.4" self.setuptools self."ZODB3-3.10.5" self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."zope.viewlet-3.7.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Registry for managing CSS and JS
        '';
      homepage = "http://pypi.python.org/pypi/Products.ResourceRegistries";
      license = "GPL version 2";
    };
  };


  "five.formlib-1.0.4" = self.buildPythonPackage {
    name = "five.formlib-1.0.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/f/five.formlib/five.formlib-1.0.4.zip";
        md5 = "09fcecbb7e0ed4a31a4f19787c1a78b4";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."ExtensionClass-2.13.2" self.setuptools self."transaction-1.1.1" self."zope.app.form-4.0.2" self."zope.browser-1.3" self."zope.component__zcml-3.9.5" self."zope.event-3.5.2" self."zope.formlib-4.0.6" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.location-3.9.1" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        zope.formlib integration for Zope 2
        '';
      homepage = "http://pypi.python.org/pypi/five.formlib";
      license = "ZPL 2.1";
    };
  };


  "Products.statusmessages-4.0" = self.buildPythonPackage {
    name = "Products.statusmessages-4.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.statusmessages/Products.statusmessages-4.0.zip";
        md5 = "265324b0a58a032dd0ed038103ed0473";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.annotation-3.5.0" self."zope.i18n__zcml-3.7.4" self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        statusmessages provides an easy way of handling internationalized status messages managed via an BrowserRequest adapter storing status messages in client-side cookies.
        '';
      homepage = "http://pypi.python.org/pypi/Products.statusmessages";
      license = "BSD";
    };
  };


  "pyramid" = self."pyramid-1.4.5";

  "pyramid-1.4.5" = self.buildPythonPackage {
    name = "pyramid-1.4.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/pyramid/pyramid-1.4.5.tar.gz";
        md5 = "321731aad69e9788b7819e257a50be1a";
    };
    doCheck = true;
    buildInputs = [ self."nose-1.3.0" self."WebTest-2.0.9" self."zope.component-4.1.0" self."zope.interface-4.0.5" ];
    propagatedBuildInputs = [ self."Chameleon-2.12" self."Mako-0.9.0" self."PasteDeploy-1.5.0" self."repoze.lru-0.6" self.setuptools self."translationstring-1.1" self."venusian-1.0a8" self."WebOb-1.2.3" self."zope.deprecation-4.0.2" self."zope.interface-4.0.5" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        The Pyramid web application development framework, a Pylons project
        '';
      homepage = "http://pylonsproject.org";
      license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
    };
  };


  "Products.contentmigration-2.1.5" = self.buildPythonPackage {
    name = "Products.contentmigration-2.1.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.contentmigration/Products.contentmigration-2.1.5.zip";
        md5 = "f08e5f2572fc6f4c61b930a17f99418f";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        A generic content migration framework for Plone.
        '';
      homepage = "http://pypi.python.org/pypi/Products.contentmigration";
      license = "LGPL";
    };
  };


  "Products.MimetypesRegistry-2.0.5" = self.buildPythonPackage {
    name = "Products.MimetypesRegistry-2.0.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.MimetypesRegistry/Products.MimetypesRegistry-2.0.5.zip";
        md5 = "1be555ad13648e139174c034631fce34";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."Products.CMFCore-2.2.7" self.setuptools self."ZODB3-3.10.5" self."zope.contenttype-3.5.5" self."zope.interface-3.6.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        MIME type handling for Zope
        '';
      homepage = "http://pypi.python.org/pypi/Products.MimetypesRegistry";
      license = "UNKNOWN";
    };
  };


  "python-dateutil-1.5" = self.buildPythonPackage {
    name = "python-dateutil-1.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-1.5.tar.gz";
        md5 = "0dcb1de5e5cad69490a3b6ab63f0cfa5";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Extensions to the standard python 2.3+ datetime module
        '';
      homepage = "http://labix.org/python-dateutil";
      license = "PSF License";
    };
  };


  "plone.app.upgrade-1.3.4" = self.buildPythonPackage {
    name = "plone.app.upgrade-1.3.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.upgrade/plone.app.upgrade-1.3.4.zip";
        md5 = "10c192ee4a2422f901e020fd5b39879a";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."borg.localrole-3.0.2" self."five.localsitemanager-2.0.5" self."plone.app.folder-1.0.5" self."plone.app.portlets-2.4.5" self."plone.portlets-2.2" self."plone.session-3.5.3" self."Products.Archetypes-1.9.4" self."Products.CMFActionIcons-2.1.3" self."Products.CMFCalendar-2.2.2" self."Products.CMFCore-2.2.7" self."Products.CMFDefault-2.2.3" self."Products.CMFDiffTool-2.1" self."Products.CMFEditions-2.2.8" self."Products.CMFFormController-3.0.3" self."Products.CMFQuickInstallerTool-3.0.6" self."Products.CMFUid-2.2.1" self."Products.contentmigration-2.1.5" self."Products.DCWorkflow-2.2.4" self."Products.GenericSetup-1.7.4" self."Products.MimetypesRegistry-2.0.5" self."Products.PloneLanguageTool-3.2.7" self."Products.PlonePAS-4.1.1" self."Products.PluggableAuthService-1.10.0" self."Products.PortalTransforms-2.1.2" self."Products.ResourceRegistries-2.2.9" self."Products.SecureMailHost-1.1.2" self."Products.ZCatalog-2.13.23" self.setuptools self."transaction-1.1.1" self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."zope.location-3.9.1" self."zope.ramcache-1.0" self."zope.site-3.9.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Upgrade machinery for Plone.
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.upgrade";
      license = "GPL version 2";
    };
  };


  "plone.intelligenttext-2.0.2" = self.buildPythonPackage {
    name = "plone.intelligenttext-2.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.intelligenttext/plone.intelligenttext-2.0.2.zip";
        md5 = "51688fa0815b49e00334e3ef948328ba";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Provides transforms from text/x-web-intelligent to text/html and vice versa.
        '';
      homepage = "http://pypi.python.org/pypi/plone.intelligenttext";
      license = "GPL version 2";
    };
  };


  "plone.namedfile__scales-2.0.2" = self.buildPythonPackage {
    name = "plone.namedfile__scales-2.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.namedfile/plone.namedfile-2.0.2.zip";
        md5 = "f6168ab9e38f3a171dc35483527b3e01";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.rfc822-1.1" self.setuptools self."zope.browserpage-3.12.2" self."zope.component__zcml-3.9.5" self."zope.security__untrustedpython-3.7.4" self."zope.traversing-3.13.2" self."plone.scale__storage-1.3.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        File types and fields for images, files and blob files with filenames
        '';
      homepage = "http://pypi.python.org/pypi/plone.namedfile";
      license = "BSD";
    };
  };


  "zope.contenttype-3.5.5" = self.buildPythonPackage {
    name = "zope.contenttype-3.5.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.contenttype/zope.contenttype-3.5.5.zip";
        md5 = "c6ac80e6887de4108a383f349fbdf332";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope contenttype
        '';
      homepage = "http://pypi.python.org/pypi/zope.contenttype";
      license = "ZPL 2.1";
    };
  };


  "zope.proxy-4.1.3" = self.buildPythonPackage {
    name = "zope.proxy-4.1.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.proxy/zope.proxy-4.1.3.zip";
        md5 = "8dbca0d33996511b9a9026da84a47109";
    };
    doCheck = true;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.interface-4.0.5" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Generic Transparent Proxies
        '';
      homepage = "http://pypi.python.org/pypi/zope.proxy";
      license = "ZPL 2.1";
    };
  };


  "zope.globalrequest-1.0" = self.buildPythonPackage {
    name = "zope.globalrequest-1.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.globalrequest/zope.globalrequest-1.0.zip";
        md5 = "ae6ff02db5ba89c1fb96ed7a73ca1cfa";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Global way of retrieving the currently active request.
        '';
      homepage = "http://pypi.python.org/pypi/zope.globalrequest";
      license = "ZPL";
    };
  };


  "zope.sendmail-3.7.5" = self.buildPythonPackage {
    name = "zope.sendmail-3.7.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.sendmail/zope.sendmail-3.7.5.tar.gz";
        md5 = "8a513ecf2b41cad849f6607bf16d6818";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."transaction-1.1.1" self."zope.component__zcml-3.9.5" self."zope.configuration-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.schema-4.2.2" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope sendmail
        '';
      homepage = "http://pypi.python.org/pypi/zope.sendmail";
      license = "ZPL 2.1";
    };
  };


  "Products.MIMETools-2.13.0" = self.buildPythonPackage {
    name = "Products.MIMETools-2.13.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.MIMETools/Products.MIMETools-2.13.0.zip";
        md5 = "ad5372fc1190599a19493db0864448ec";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."DocumentTemplate-2.13.2" self.setuptools ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        MIMETools provides the &lt;!--#mime--&gt; tag for DocumentTemplate.
        '';
      homepage = "http://pypi.python.org/pypi/Products.MIMETools";
      license = "ZPL 2.1";
    };
  };


  "zope.annotation-3.5.0" = self.buildPythonPackage {
    name = "zope.annotation-3.5.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.annotation/zope.annotation-3.5.0.tar.gz";
        md5 = "4238153279d3f30ab5613438c8e76380";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."ZODB3-3.10.5" self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."zope.location-3.9.1" self."zope.proxy-3.6.1" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Object annotation mechanism
        '';
      homepage = "http://pypi.python.org/pypi/zope.annotation";
      license = "ZPL 2.1";
    };
  };


  "plone.app.customerize-1.2.2" = self.buildPythonPackage {
    name = "plone.app.customerize-1.2.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.customerize/plone.app.customerize-1.2.2.zip";
        md5 = "6a3802c4e8fbd955597adc6a8298febf";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."five.customerize-1.1" self."plone.browserlayer-2.1.2" self."plone.portlets-2.2" self."Products.CMFCore-2.2.7" self.setuptools self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."zope.publisher-3.12.6" self."zope.viewlet-3.7.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Integrate five.customerize into Plone.
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.customerize/";
      license = "GPL version 2";
    };
  };


  "plone.app.registry-1.2.3" = self.buildPythonPackage {
    name = "plone.app.registry-1.2.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.registry/plone.app.registry-1.2.3.zip";
        md5 = "b2269e10516e8f2faf83545e3d0163d8";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."lxml-2.3.6" self."plone.app.z3cform-0.7.4" self."plone.autoform-1.5" self."plone.registry-1.0.1" self."plone.supermodel-1.2.3" self."Products.CMFCore-2.2.7" self."Products.CMFPlone-4.3.2" self."Products.GenericSetup-1.7.4" self."Products.statusmessages-4.0" self.setuptools self."zope.component__zcml-3.9.5" self."zope.dottedname-3.4.6" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Zope 2 and Plone  integration for plone.registry
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.registry";
      license = "GPL";
    };
  };


  "plone.session-3.5.3" = self.buildPythonPackage {
    name = "plone.session-3.5.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.session/plone.session-3.5.3.zip";
        md5 = "f95872454735abc8f27c3dcbc9434c11";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.keyring-2.0.1" self."plone.protect-2.0.2" self."Products.PluggableAuthService-1.10.0" self.setuptools self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Session based authentication for Zope
        '';
      homepage = "http://pypi.python.org/pypi/plone.session";
      license = "BSD";
    };
  };


  "z3c.caching__zcml-2.0a1" = self.buildPythonPackage {
    name = "z3c.caching__zcml-2.0a1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/z3c.caching/z3c.caching-2.0a1.tar.gz";
        md5 = "17f250b5084c2324a7d15c6810ee628e";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.browser-1.3" self."zope.component__zcml-3.9.5" self."zope.event-3.5.2" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.configuration-3.7.4" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Caching infrastructure for web apps
        '';
      homepage = "UNKNOWN";
      license = "ZPL";
    };
  };


  "Products.ZCTextIndex-2.13.4" = self.buildPythonPackage {
    name = "Products.ZCTextIndex-2.13.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.ZCTextIndex/Products.ZCTextIndex-2.13.4.zip";
        md5 = "8bbfa5fcd3609246990a9314d6f826b4";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."AccessControl-3.0.8" self."Acquisition-2.13.8" self."Persistence-2.13.2" self.setuptools self."transaction-1.1.1" self."zExceptions-2.13.0" self."ZODB3-3.10.5" self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Full text indexing for ZCatalog / Zope 2.
        '';
      homepage = "http://pypi.python.org/pypi/Products.ZCTextIndex";
      license = "ZPL 2.1";
    };
  };


  "zope.filerepresentation-3.6.1" = self.buildPythonPackage {
    name = "zope.filerepresentation-3.6.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.filerepresentation/zope.filerepresentation-3.6.1.tar.gz";
        md5 = "4a7a434094f4bfa99a7f22e75966c359";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.interface-3.6.7" self."zope.schema-4.2.2" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        File-system Representation Interfaces
        '';
      homepage = "http://pypi.python.org/pypi/zope.filerepresentation";
      license = "ZPL 2.1";
    };
  };


  "plone.memoize-1.1.1" = self.buildPythonPackage {
    name = "plone.memoize-1.1.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.memoize/plone.memoize-1.1.1.zip";
        md5 = "d07cd14b976160e1f26a859e3370147e";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.annotation-3.5.0" self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."zope.ramcache-1.0" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Decorators for caching the values of functions and methods
        '';
      homepage = "http://pypi.python.org/pypi/plone.memoize";
      license = "GPL version 2";
    };
  };


  "zope.interface-3.6.7" = self.buildPythonPackage {
    name = "zope.interface-3.6.7";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.interface/zope.interface-3.6.7.zip";
        md5 = "9df962180fbbb54eb1875cff9fe436e5";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Interfaces for Python
        '';
      homepage = "http://pypi.python.org/pypi/zope.interface";
      license = "ZPL 2.1";
    };
  };


  "zope.size-3.4.1" = self.buildPythonPackage {
    name = "zope.size-3.4.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.size/zope.size-3.4.1.tar.gz";
        md5 = "55d9084dfd9dcbdb5ad2191ceb5ed03d";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Interfaces and simple adapter that give the size of an object
        '';
      homepage = "http://pypi.python.org/pypi/zope.size";
      license = "ZPL 2.1";
    };
  };


  "ZODB3-3.10.5" = self.buildPythonPackage {
    name = "ZODB3-3.10.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/Z/ZODB3/ZODB3-3.10.5.tar.gz";
        md5 = "6f180c6897a1820948fee2a6290503cd";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."transaction-1.1.1" self."zc.lockfile-1.0.2" self."ZConfig-2.9.1" self."zdaemon-2.0.7" self."zope.event-3.5.2" self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope Object Database: object database and persistence
        '';
      homepage = "UNKNOWN";
      license = "ZPL 2.1";
    };
  };


  "five.customerize-1.1" = self.buildPythonPackage {
    name = "five.customerize-1.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/f/five.customerize/five.customerize-1.1.zip";
        md5 = "80772212a2d55150a6c070fc4638b0c7";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."plone.portlets-2.2" self.setuptools self."transaction-1.1.1" self."zope.component__zcml-3.9.5" self."zope.componentvocabulary-1.0.1" self."zope.dottedname-3.4.6" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.pagetemplate-3.6.3" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.site-3.9.2" self."zope.testing-3.9.7" self."zope.traversing-3.13.2" self."zope.viewlet-3.7.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        TTW customization of template-based Zope views
        '';
      homepage = "http://pypi.python.org/pypi/five.customerize";
      license = "ZPL 2.1";
    };
  };


  "zope.dottedname-3.4.6" = self.buildPythonPackage {
    name = "zope.dottedname-3.4.6";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.dottedname/zope.dottedname-3.4.6.tar.gz";
        md5 = "62d639f75b31d2d864fe5982cb23959c";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Resolver for Python dotted names.
        '';
      homepage = "http://pypi.python.org/pypi/zope.dottedname";
      license = "ZPL 2.1";
    };
  };


  "plone.resource-1.0.2" = self.buildPythonPackage {
    name = "plone.resource-1.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.resource/plone.resource-1.0.2.zip";
        md5 = "594d41e3acd913ae92f2e9ef96503b9f";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.caching-1.0" self."python-dateutil-1.5" self.setuptools self."z3c.caching__zcml-2.0a1" self."zope.component__zcml-3.9.5" self."zope.configuration-3.7.4" self."zope.filerepresentation-3.6.1" self."zope.interface-3.6.7" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.traversing-3.13.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        UNKNOWN
        '';
      homepage = "https://svn.plone.org/svn/plone/plone.resource";
      license = "GPL";
    };
  };


  "Products.DCWorkflow-2.2.4" = self.buildPythonPackage {
    name = "Products.DCWorkflow-2.2.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.DCWorkflow/Products.DCWorkflow-2.2.4.tar.gz";
        md5 = "c90a16c4f3611015592ba8173a5f1863";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."Products.CMFCore-2.2.7" self."Products.GenericSetup-1.7.4" self.setuptools self."Zope2-2.13.21" self."eggtestinfo-0.3" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        DCWorkflow product for the Zope Content Management Framework
        '';
      homepage = "http://pypi.python.org/pypi/Products.DCWorkflow";
      license = "ZPL 2.1 (http://www.zope.org/Resources/License/ZPL-2.1)";
    };
  };


  "plone.app.locales-4.3.2" = self.buildPythonPackage {
    name = "plone.app.locales-4.3.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.locales/plone.app.locales-4.3.2.zip";
        md5 = "c06d6574c1e1df4e253b80751a468ad5";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Translation files for Plone
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.locales";
      license = "GPL version 2";
    };
  };


  "collective.z3cform.datetimewidget-1.2.5" = self.buildPythonPackage {
    name = "collective.z3cform.datetimewidget-1.2.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/c/collective.z3cform.datetimewidget/collective.z3cform.datetimewidget-1.2.5.zip";
        md5 = "38fa463ea9b0b3cf5f61540250968214";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."z3c.form-3.0.2" self."zope.deprecation-3.4.1" self."zope.i18n__zcml-3.7.4" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        z3c.form date and datetime widgets
        '';
      homepage = "https://github.com/collective/collective.z3cform.datetimewidget";
      license = "GPL version 2";
    };
  };


  "Zope2-2.13.21" = self.buildPythonPackage {
    name = "Zope2-2.13.21";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/Z/Zope2/Zope2-2.13.21.zip";
        md5 = "7d6e1661e365ee562fea9d3593f03f0e";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."AccessControl-3.0.8" self."Acquisition-2.13.8" self."DateTime-3.0.3" self."DocumentTemplate-2.13.2" self."docutils-0.9.1" self."ExtensionClass-2.13.2" self."initgroups-2.13.0" self."Missing-2.13.1" self."MultiMapping-2.13.0" self."Persistence-2.13.2" self."Products.BTreeFolder2-2.13.3" self."Products.ExternalMethod-2.13.0" self."Products.MailHost-2.13.1" self."Products.MIMETools-2.13.0" self."Products.OFSP-2.13.2" self."Products.PythonScripts-2.13.2" self."Products.StandardCacheManagers-2.13.0" self."Products.ZCatalog-2.13.23" self."Products.ZCTextIndex-2.13.4" self."pytz-2013b" self."Record-2.13.0" self."RestrictedPython-3.6.0" self.setuptools self."tempstorage-2.12.2" self."transaction-1.1.1" self."ZConfig-2.9.1" self."zdaemon-2.0.7" self."zExceptions-2.13.0" self."zLOG-2.11.1" self."ZODB3-3.10.5" self."zope.browser-1.3" self."zope.browsermenu-3.9.1" self."zope.browserpage-3.12.2" self."zope.browserresource-3.10.3" self."zope.component__zcml-3.9.5" self."zope.configuration-3.7.4" self."zope.container-3.11.2" self."zope.contentprovider-3.7.2" self."zope.contenttype-3.5.5" self."zope.deferredimport-3.5.3" self."zope.event-3.5.2" self."zope.exceptions-3.6.2" self."zope.i18n__zcml-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.location-3.9.1" self."zope.pagetemplate-3.6.3" self."zope.processlifetime-1.0" self."zope.proxy-3.6.1" self."zope.ptresource-3.9.0" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.security__untrustedpython-3.7.4" self."zope.sendmail-3.7.5" self."zope.sequencesort-3.4.0" self."zope.site-3.9.2" self."zope.size-3.4.1" self."zope.structuredtext-3.5.1" self."zope.tal-3.5.2" self."zope.tales-3.5.3" self."zope.testbrowser-3.11.1" self."zope.testing-3.9.7" self."zope.traversing-3.13.2" self."zope.viewlet-3.7.2" self."ZopeUndo-2.12.0" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope2 application server / web framework
        '';
      homepage = "http://zope2.zope.org";
      license = "ZPL 2.1";
    };
  };


  "Products.ExternalMethod-2.13.0" = self.buildPythonPackage {
    name = "Products.ExternalMethod-2.13.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.ExternalMethod/Products.ExternalMethod-2.13.0.zip";
        md5 = "15ba953ef6cb632eb571977651252ea6";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."AccessControl-3.0.8" self."Acquisition-2.13.8" self."ExtensionClass-2.13.2" self."Persistence-2.13.2" self.setuptools self."ZODB3-3.10.5" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        This package provides support for external Python methods within a Zope 2 environment.
        '';
      homepage = "http://pypi.python.org/pypi/Products.ExternalMethod";
      license = "ZPL 2.1";
    };
  };


  "plone.app.workflow-2.1.6" = self.buildPythonPackage {
    name = "plone.app.workflow-2.1.6";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.workflow/plone.app.workflow-2.1.6.zip";
        md5 = "68a76865382b9db82aaa60c16efb1d14";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self."plone.memoize-1.1.1" self."Products.CMFCore-2.2.7" self."Products.DCWorkflow-2.2.4" self."Products.GenericSetup-1.7.4" self."Products.statusmessages-4.0" self.setuptools self."transaction-1.1.1" self."zope.component__zcml-3.9.5" self."zope.i18n__zcml-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.schema-4.2.2" self."zope.site-3.9.2" self."zope.testing-3.9.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        workflow and security settings for Plone
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.workflow";
      license = "GPL version 2";
    };
  };


  "plone.browserlayer-2.1.2" = self.buildPythonPackage {
    name = "plone.browserlayer-2.1.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.browserlayer/plone.browserlayer-2.1.2.zip";
        md5 = "bce02f4907a4f29314090c525e5fc28e";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Products.CMFCore-2.2.7" self."Products.GenericSetup-1.7.4" self.setuptools self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."zope.traversing-3.13.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Browser layer management for Zope 2 applications
        '';
      homepage = "http://pypi.python.org/pypi/plone.browserlayer";
      license = "GPL version 2";
    };
  };


  "plone.app.folder-1.0.5" = self.buildPythonPackage {
    name = "plone.app.folder-1.0.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.folder/plone.app.folder-1.0.5.zip";
        md5 = "8ea860daddb4c93c0b7f2b5f7106fef0";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.folder-1.0.4" self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Integration package for `plone.folder` into Plone
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.folder/";
      license = "GPL version 2";
    };
  };


  "Chameleon-2.12" = self.buildPythonPackage {
    name = "Chameleon-2.12";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/C/Chameleon/Chameleon-2.12.tar.gz";
        md5 = "c2947c7b615bf758fa4a710e759c658b";
    };
    doCheck = false;
    buildInputs = [ self."zope.event-4.0.2" ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Fast HTML/XML Template Compiler.
        '';
      homepage = "http://www.pagetemplates.org/";
      license = "BSD-like (http://repoze.org/license.html)";
    };
  };


  "Products.StandardCacheManagers-2.13.0" = self.buildPythonPackage {
    name = "Products.StandardCacheManagers-2.13.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.StandardCacheManagers/Products.StandardCacheManagers-2.13.0.zip";
        md5 = "c5088b2b62bd26d63d9579a04369cb73";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."AccessControl-3.0.8" self.setuptools self."transaction-1.1.1" self."zope.component__zcml-3.9.5" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Cache managers for Zope 2.
        '';
      homepage = "http://pypi.python.org/pypi/Products.StandardCacheManagers";
      license = "ZPL 2.1";
    };
  };


  "RestrictedPython-3.6.0" = self.buildPythonPackage {
    name = "RestrictedPython-3.6.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/R/RestrictedPython/RestrictedPython-3.6.0.zip";
        md5 = "aa75a7dcc7fbc966357837cc66cacec6";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        RestrictedPython provides a restricted execution environment for Python, e.g. for running untrusted code.
        '';
      homepage = "http://pypi.python.org/pypi/RestrictedPython";
      license = "ZPL 2.1";
    };
  };


  "tempstorage-2.12.2" = self.buildPythonPackage {
    name = "tempstorage-2.12.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/t/tempstorage/tempstorage-2.12.2.zip";
        md5 = "7a2b76b39839e229249b1bb175604480";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."ZODB3-3.10.5" self."zope.testing-3.9.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        A RAM-based storage for ZODB
        '';
      homepage = "http://pypi.python.org/pypi/tempstorage";
      license = "ZPL 2.1";
    };
  };


  "plone.app.uuid-1.0" = self.buildPythonPackage {
    name = "plone.app.uuid-1.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.uuid/plone.app.uuid-1.0.zip";
        md5 = "9ca8dcfb09a8a0d6bbee0f28073c3d3f";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.indexer-1.0.2" self."plone.uuid-1.0.3" self.setuptools self."zope.interface-3.6.7" self."zope.publisher-3.12.6" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Plone integration for the basic plone.uuid package
        '';
      homepage = "http://plone.org";
      license = "GPL";
    };
  };


  "Acquisition-2.13.8" = self.buildPythonPackage {
    name = "Acquisition-2.13.8";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/A/Acquisition/Acquisition-2.13.8.zip";
        md5 = "8c33160c157b50649e2b2b3224622579";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."ExtensionClass-2.13.2" self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Acquisition is a mechanism that allows objects to obtain attributes from the containment hierarchy they're in.
        '';
      homepage = "http://pypi.python.org/pypi/Acquisition";
      license = "ZPL 2.1";
    };
  };


  "zope.datetime-3.4.1" = self.buildPythonPackage {
    name = "zope.datetime-3.4.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.datetime/zope.datetime-3.4.1.tar.gz";
        md5 = "4dde22d34f41a0a4f0c5a345e6d11ee9";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Zope datetime
        '';
      homepage = "http://pypi.python.org/pypi/zope.datetime";
      license = "ZPL 2.1";
    };
  };


  "lxml-2.3.6" = self.buildPythonPackage {
    name = "lxml-2.3.6";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/l/lxml/lxml-2.3.6.tar.gz";
        md5 = "d5d886088e78b1bdbfd66d328fc2d0bc";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Powerful and Pythonic XML processing library combining libxml2/libxslt with the ElementTree API.
        '';
      homepage = "http://lxml.de/";
      license = "UNKNOWN";
    };
  };


  "plone.app.dexterity-2.0.9" = self.buildPythonPackage {
    name = "plone.app.dexterity-2.0.9";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.dexterity/plone.app.dexterity-2.0.9.zip";
        md5 = "aa9d6ee719a6918f99f0aa0066ebf024";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."collective.z3cform.datetimewidget-1.2.5" self."lxml-2.3.6" self."plone.app.content-2.1.3" self."plone.app.layout-2.3.7" self."plone.app.textfield-1.2.2" self."plone.app.uuid-1.0" self."plone.app.z3cform-0.7.4" self."plone.autoform-1.5" self."plone.behavior-1.0.2" self."plone.contentrules-2.0.3" self."plone.dexterity-2.1.3" self."plone.formwidget.namedfile-1.0.7" self."plone.namedfile__scales-2.0.2" self."plone.portlets-2.2" self."plone.rfc822-1.1" self."plone.schemaeditor-1.3.3" self."plone.supermodel-1.2.3" self."plone.z3cform-0.8.0" self."Products.CMFCore-2.2.7" self."Products.CMFPlone-4.3.2" self."Products.GenericSetup-1.7.4" self.setuptools self."z3c.form-3.0.2" self."zope.browserpage-3.12.2" self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Dexterity is a content type framework for CMF applications, with particular emphasis on Plone. It can be viewed as an alternative to Archetypes that is more light-weight and modular.
        '';
      homepage = "http://plone.org/products/dexterity";
      license = "GPL";
    };
  };


  "zope.location-4.0.2" = self.buildPythonPackage {
    name = "zope.location-4.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.location/zope.location-4.0.2.zip";
        md5 = "44d865b2c0b1e1cc93898c7df938d353";
    };
    doCheck = true;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.interface-4.0.5" self."zope.proxy-4.1.3" self."zope.schema-4.3.2" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope Location
        '';
      homepage = "http://pypi.python.org/pypi/zope.location/";
      license = "ZPL 2.1";
    };
  };


  "zope.app.locales-3.6.2" = self.buildPythonPackage {
    name = "zope.app.locales-3.6.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.app.locales/zope.app.locales-3.6.2.tar.gz";
        md5 = "bd2b4c6040e768f33004b1210d3207fa";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Zope locale extraction and management utilities
        '';
      homepage = "http://pypi.python.org/pypi/zope.app.locales";
      license = "ZPL 2.1";
    };
  };


  "five.globalrequest-1.0" = self.buildPythonPackage {
    name = "five.globalrequest-1.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/f/five.globalrequest/five.globalrequest-1.0.tar.gz";
        md5 = "87f8996bd21d4aa156aa26e7d21b8744";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.globalrequest-1.0" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Zope 2 integration for zope.globalrequest
        '';
      homepage = "http://pypi.python.org/pypi/five.globalrequest";
      license = "ZPL";
    };
  };


  "plone.indexer-1.0.2" = self.buildPythonPackage {
    name = "plone.indexer-1.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.indexer/plone.indexer-1.0.2.zip";
        md5 = "538aeee1f9db78bc8c85ae1bcb0153ed";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Products.CMFCore-2.2.7" self.setuptools self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Hooks to facilitate managing custom index values in Zope 2/CMF applications
        '';
      homepage = "http://pypi.python.org/pypi/plone.indexer";
      license = "BSD";
    };
  };


  "plone.app.layout-2.3.7" = self.buildPythonPackage {
    name = "plone.app.layout-2.3.7";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.layout/plone.app.layout-2.3.7.zip";
        md5 = "c68be1efeef54124211a676d0dbaa655";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self."plone.app.portlets-2.4.5" self."plone.app.viewletmanager-2.0.4" self."plone.i18n-2.0.9" self."plone.locking-2.0.4" self."plone.memoize-1.1.1" self."plone.portlets-2.2" self."Products.CMFCore-2.2.7" self."Products.CMFDefault-2.2.3" self."Products.CMFDynamicViewFTI-4.0.5" self."Products.CMFEditions-2.2.8" self.setuptools self."zope.annotation-3.5.0" self."zope.component__zcml-3.9.5" self."zope.deprecation-3.4.1" self."zope.dottedname-3.4.6" self."zope.i18n__zcml-3.7.4" self."zope.interface-3.6.7" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.viewlet-3.7.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Layout mechanisms for Plone
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.layout";
      license = "GPL version 2";
    };
  };


  "zope.app.content-3.5.1" = self.buildPythonPackage {
    name = "zope.app.content-3.5.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.app.content/zope.app.content-3.5.1.tar.gz";
        md5 = "0ac6a6fcb5dd6f845759f998d8e8cbb3";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.componentvocabulary-1.0.1" self."zope.interface-3.6.7" self."zope.schema-4.2.2" self."zope.security__untrustedpython-3.7.4" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Zope Content Type
        '';
      homepage = "http://cheeseshop.python.org/pypi/zope.app.content";
      license = "ZPL 2.1";
    };
  };


  "mechanize-0.2.5" = self.buildPythonPackage {
    name = "mechanize-0.2.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/m/mechanize/mechanize-0.2.5.tar.gz";
        md5 = "32657f139fc2fb75bcf193b63b8c60b2";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Stateful programmatic web browsing.
        '';
      homepage = "http://wwwsearch.sourceforge.net/mechanize/";
      license = "BSD";
    };
  };


  "z3c.formwidget.query-0.9" = self.buildPythonPackage {
    name = "z3c.formwidget.query-0.9";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/z3c.formwidget.query/z3c.formwidget.query-0.9.zip";
        md5 = "d9f7960b1a5a81d8ba5241530f496522";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."z3c.form-3.0.2" self."zope.component__zcml-3.9.5" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.schema-4.2.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        A source query widget for z3c.form.
        '';
      homepage = "http://pypi.python.org/pypi/z3c.formwidget.query";
      license = "ZPL 2.1";
    };
  };


  "plone.app.z3cform-0.7.4" = self.buildPythonPackage {
    name = "plone.app.z3cform-0.7.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.z3cform/plone.app.z3cform-0.7.4.zip";
        md5 = "6350db39b32c3bf6edbb820b91b70b0f";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."collective.z3cform.datetimewidget-1.2.5" self."plone.protect-2.0.2" self."plone.z3cform-0.8.0" self.setuptools self."z3c.formwidget.query-0.9" self."zope.browserpage-3.12.2" self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."zope.traversing-3.13.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        A collection of widgets, templates and other components for use with z3c.form and Plone
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.z3cform";
      license = "GPL";
    };
  };


  "plone.app.querystring-1.0.8" = self.buildPythonPackage {
    name = "plone.app.querystring-1.0.8";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.querystring/plone.app.querystring-1.0.8.zip";
        md5 = "3ad2155da0dd5c6b99643551ad494607";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."DateTime-3.0.3" self."plone.app.contentlisting-1.0.5" self."plone.app.layout-2.3.7" self."plone.app.vocabularies-2.1.11" self."plone.registry-1.0.1" self."Products.CMFCore-2.2.7" self.setuptools self."zope.component__zcml-3.9.5" self."zope.dottedname-3.4.6" self."zope.globalrequest-1.0" self."zope.i18n__zcml-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        UNKNOWN
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.querystring";
      license = "GPL version 2";
    };
  };


  "zope.interface-4.0.5" = self.buildPythonPackage {
    name = "zope.interface-4.0.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.interface/zope.interface-4.0.5.zip";
        md5 = "caf26025ae1b02da124a58340e423dfe";
    };
    doCheck = true;
    buildInputs = [ self."zope.event-4.0.2" pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Interfaces for Python
        '';
      homepage = "http://pypi.python.org/pypi/zope.interface";
      license = "ZPL 2.1";
    };
  };


  "Products.PasswordResetTool-2.0.15" = self.buildPythonPackage {
    name = "Products.PasswordResetTool-2.0.15";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.PasswordResetTool/Products.PasswordResetTool-2.0.15.zip";
        md5 = "74b46348d023052285124683bf122272";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self."plone.memoize-1.1.1" self."Products.CMFCore-2.2.7" self.setuptools self."zope.component__zcml-3.9.5" self."zope.i18n__zcml-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Password reset tool for Plone
        '';
      homepage = "http://pypi.python.org/pypi/Products.PasswordResetTool";
      license = "GPL";
    };
  };


  "plone.portlet.static-2.0.2" = self.buildPythonPackage {
    name = "plone.portlet.static-2.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.portlet.static/plone.portlet.static-2.0.2.zip";
        md5 = "ec0dc691b4191a41ff97779b117f9985";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.app.form-2.2.3" self."plone.app.portlets-2.4.5" self."plone.i18n-2.0.9" self."plone.portlets-2.2" self.setuptools self."zope.component__zcml-3.9.5" self."zope.formlib-4.0.6" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.schema-4.2.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        A simple static HTML portlet for Plone.
        '';
      homepage = "http://pypi.python.org/pypi/plone.portlet.static";
      license = "GPL version 2";
    };
  };


  "plone.i18n-2.0.9" = self.buildPythonPackage {
    name = "plone.i18n-2.0.9";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.i18n/plone.i18n-2.0.9.zip";
        md5 = "8e8ceffc64f04beecf1579a24edc2670";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."Unidecode-0.04.1" self."zope.component__zcml-3.9.5" self."zope.i18n__zcml-3.7.4" self."zope.interface-3.6.7" self."zope.publisher-3.12.6" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Advanced i18n/l10n features
        '';
      homepage = "http://pypi.python.org/pypi/plone.i18n";
      license = "GPL version 2";
    };
  };


  "Missing-2.13.1" = self.buildPythonPackage {
    name = "Missing-2.13.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/M/Missing/Missing-2.13.1.zip";
        md5 = "9823cff54444cbbcaef8fc45d8e42572";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."ExtensionClass-2.13.2" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Special Missing objects used in Zope2.
        '';
      homepage = "http://pypi.python.org/pypi/Missing";
      license = "ZPL 2.1";
    };
  };


  "zope.cachedescriptors-3.5.1" = self.buildPythonPackage {
    name = "zope.cachedescriptors-3.5.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.cachedescriptors/zope.cachedescriptors-3.5.1.zip";
        md5 = "263459a95238fd61d17e815d97ca49ce";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Method and property caching decorators
        '';
      homepage = "http://pypi.python.org/pypi/zope.cachedescriptors";
      license = "ZPL 2.1";
    };
  };


  "zope.browsermenu-3.9.1" = self.buildPythonPackage {
    name = "zope.browsermenu-3.9.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.browsermenu/zope.browsermenu-3.9.1.zip";
        md5 = "a47c7b1e786661c912a1150bf8d1f83f";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.browser-1.3" self."zope.component__zcml-3.9.5" self."zope.configuration-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.pagetemplate-3.6.3" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.security__untrustedpython-3.7.4" self."zope.traversing-3.13.2" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Browser menu implementation for Zope.
        '';
      homepage = "http://pypi.python.org/pypi/zope.browsermenu/";
      license = "UNKNOWN";
    };
  };


  "archetypes.referencebrowserwidget-2.4.19" = self.buildPythonPackage {
    name = "archetypes.referencebrowserwidget-2.4.19";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/a/archetypes.referencebrowserwidget/archetypes.referencebrowserwidget-2.4.19.zip";
        md5 = "b70af6b2da6d8c57c1138a52e94e588c";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.app.form-2.2.3" self."plone.app.jquerytools-1.5.6" self.setuptools self."zope.component__zcml-3.9.5" self."zope.formlib-4.0.6" self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        A referencebrowser implementation for Archetypes
        '';
      homepage = "http://pypi.python.org/pypi/archetypes.referencebrowserwidget";
      license = "ZPL 2.1";
    };
  };


  "plone.app.jquery-1.7.2" = self.buildPythonPackage {
    name = "plone.app.jquery-1.7.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.jquery/plone.app.jquery-1.7.2.tar.gz";
        md5 = "e204cf45456d26217263531832b5bdac";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."Products.CMFCore-2.2.7" self."Products.GenericSetup-1.7.4" self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        jQuery integration for Plone
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.jquery";
      license = "GPL version 2";
    };
  };


  "venusian-1.0a8" = self.buildPythonPackage {
    name = "venusian-1.0a8";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/v/venusian/venusian-1.0a8.tar.gz";
        md5 = "a1a72166fd7cccf0f30e3305e09ce5cf";
    };
    doCheck = false;
    buildInputs = [ self."nose-1.3.0" ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        A library for deferring decorator actions
        '';
      homepage = "http://pylonsproject.org";
      license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
    };
  };


  "WebTest-2.0.9" = self.buildPythonPackage {
    name = "WebTest-2.0.9";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/W/WebTest/WebTest-2.0.9.zip";
        md5 = "bf0a04fcf8b2cdcaa13b04324cefb53d";
    };
    doCheck = true;
    buildInputs = [ self."nose-1.3.0" self."unittest2-0.5.1" self."pyquery-1.2.6" self."WSGIProxy2-0.3" self."PasteDeploy-1.5.0" self."mock-1.0.1" self."coverage-3.7" pkgs.unzip ];
    propagatedBuildInputs = [ self."beautifulsoup4-4.3.2" self."six-1.4.1" self."waitress-0.8.7" self."WebOb-1.2.3" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Helper to test WSGI applications
        '';
      homepage = "http://webtest.pythonpaste.org/";
      license = "MIT";
    };
  };


  "plone.app.contentmenu-2.0.8" = self.buildPythonPackage {
    name = "plone.app.contentmenu-2.0.8";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.contentmenu/plone.app.contentmenu-2.0.8.zip";
        md5 = "8ba463f1a164c454c70d26507e5bd22a";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."plone.app.content-2.1.3" self."plone.locking-2.0.4" self."plone.memoize-1.1.1" self."Products.CMFCore-2.2.7" self."Products.CMFDynamicViewFTI-4.0.5" self.setuptools self."zope.browsermenu-3.9.1" self."zope.component__zcml-3.9.5" self."zope.contentprovider-3.7.2" self."zope.i18n__zcml-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.publisher-3.12.6" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Plone's content menu implementation
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.contentmenu";
      license = "GPL version 2";
    };
  };


  "plone.contentrules-2.0.3" = self.buildPythonPackage {
    name = "plone.contentrules-2.0.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.contentrules/plone.contentrules-2.0.3.zip";
        md5 = "e743dca41b07b7ac1c2a65b652679201";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."ZODB3-3.10.5" self."zope.annotation-3.5.0" self."zope.component__zcml-3.9.5" self."zope.componentvocabulary-1.0.1" self."zope.configuration-3.7.4" self."zope.container-3.11.2" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.schema-4.2.2" self."zope.testing-3.9.7" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Plone ContentRules Engine
        '';
      homepage = "http://pypi.python.org/pypi/plone.contentrules";
      license = "GPL version 2";
    };
  };


  "plone.protect-2.0.2" = self.buildPythonPackage {
    name = "plone.protect-2.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.protect/plone.protect-2.0.2.zip";
        md5 = "74925ffb08782e72f9b1e850fa78fffa";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.keyring-2.0.1" self.setuptools self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Security for browser forms
        '';
      homepage = "http://pypi.python.org/pypi/plone.protect";
      license = "BSD";
    };
  };


  "transaction-1.1.1" = self.buildPythonPackage {
    name = "transaction-1.1.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/t/transaction/transaction-1.1.1.tar.gz";
        md5 = "30b062baa34fe1521ad979fb088c8c55";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Transaction management for Python
        '';
      homepage = "http://www.zope.org/Products/ZODB";
      license = "ZPL 2.1";
    };
  };


  "plone.app.theming-1.1.1" = self.buildPythonPackage {
    name = "plone.app.theming-1.1.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.theming/plone.app.theming-1.1.1.zip";
        md5 = "a694b7a050b6e7c25d720d1e99bb73fa";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."diazo-1.0.4" self."docutils-0.9.1" self."five.globalrequest-1.0" self."lxml-2.3.6" self."plone.app.registry-1.2.3" self."plone.resource-1.0.2" self."plone.resourceeditor-1.0" self."plone.subrequest-1.6.7" self."plone.transformchain-1.0.3" self."Products.CMFPlone-4.3.2" self."repoze.xmliter-0.5" self."roman-1.4.0" self.setuptools self."zope.traversing-3.13.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Integrates the Diazo theming engine with Plone
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.theming";
      license = "GPL";
    };
  };


  "borg.localrole-3.0.2" = self.buildPythonPackage {
    name = "borg.localrole-3.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/b/borg.localrole/borg.localrole-3.0.2.zip";
        md5 = "04082694dfda9ae5cda62747b8ac7ccf";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."plone.memoize-1.1.1" self."Products.CMFCore-2.2.7" self."Products.GenericSetup-1.7.4" self."Products.PlonePAS-4.1.1" self."Products.PluggableAuthService-1.10.0" self.setuptools self."zope.annotation-3.5.0" self."zope.component__zcml-3.9.5" self."zope.deferredimport-3.5.3" self."zope.interface-3.6.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        A PAS plugin which can manage local roles via an adapter lookup on the current context
        '';
      homepage = "http://pypi.python.org/pypi/borg.localrole";
      license = "LGPL";
    };
  };


  "Products.ZCatalog-2.13.23" = self.buildPythonPackage {
    name = "Products.ZCatalog-2.13.23";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.ZCatalog/Products.ZCatalog-2.13.23.zip";
        md5 = "d425171516dfc70e543a4e2b852301cb";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."AccessControl-3.0.8" self."Acquisition-2.13.8" self."DateTime-3.0.3" self."DocumentTemplate-2.13.2" self."ExtensionClass-2.13.2" self."Missing-2.13.1" self."Persistence-2.13.2" self."Products.ZCTextIndex-2.13.4" self."Record-2.13.0" self."RestrictedPython-3.6.0" self.setuptools self."zExceptions-2.13.0" self."ZODB3-3.10.5" self."zope.dottedname-3.4.6" self."zope.interface-3.6.7" self."zope.schema-4.2.2" self."zope.testing-3.9.7" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Zope 2's indexing and search solution.
        '';
      homepage = "http://pypi.python.org/pypi/Products.ZCatalog";
      license = "ZPL 2.1";
    };
  };


  "plone.app.discussion-2.2.8" = self.buildPythonPackage {
    name = "plone.app.discussion-2.2.8";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.discussion/plone.app.discussion-2.2.8.zip";
        md5 = "97cc5b204076f8803fcdaccbf0565bb6";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."collective.monkeypatcher-1.0.1" self."plone.app.layout-2.3.7" self."plone.app.uuid-1.0" self."plone.app.z3cform-0.7.4" self."plone.indexer-1.0.2" self."plone.registry-1.0.1" self."plone.z3cform-0.8.0" self.setuptools self."z3c.form-3.0.2" self."ZODB3-3.10.5" self."zope.annotation-3.5.0" self."zope.component__zcml-3.9.5" self."zope.container-3.11.2" self."zope.event-3.5.2" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.site-3.9.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Enhanced discussion support for Plone
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.discussion";
      license = "GPL";
    };
  };


  "Products.TinyMCE-1.3.5" = self.buildPythonPackage {
    name = "Products.TinyMCE-1.3.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.TinyMCE/Products.TinyMCE-1.3.5.zip";
        md5 = "b972ff26c90d99c13ded0aeb33af2a2e";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.app.imaging-1.0.9" self."plone.app.layout-2.3.7" self."plone.caching-1.0" self."plone.namedfile__scales-2.0.2" self."plone.outputfilters-1.11.1" self."Products.ResourceRegistries-2.2.9" self.setuptools self."zope.app.content-3.5.1" self."zope.schema-4.2.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Adds support for TinyMCE, a platform independent web based Javascript HTML WYSIWYG editor, to Plone.
        '';
      homepage = "http://plone.org/products/tinymce";
      license = "LGPL";
    };
  };


  "plone.supermodel-1.2.3" = self.buildPythonPackage {
    name = "plone.supermodel-1.2.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.supermodel/plone.supermodel-1.2.3.zip";
        md5 = "34610edccd7f93409b95a6b9ecd3da9e";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."lxml-2.3.6" self.setuptools self."z3c.zcmlhook-1.0b1" self."zope.component__zcml-3.9.5" self."zope.deferredimport-3.5.3" self."zope.dottedname-3.4.6" self."zope.interface-3.6.7" self."zope.schema-4.2.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Serialize Zope schema definitions to and from XML
        '';
      homepage = "http://code.google.com/p/dexterity";
      license = "BSD";
    };
  };


  "zope.exceptions-3.6.2" = self.buildPythonPackage {
    name = "zope.exceptions-3.6.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.exceptions/zope.exceptions-3.6.2.tar.gz";
        md5 = "d7234d99d728abe3d9275346e8d24fd9";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope Exceptions
        '';
      homepage = "http://cheeseshop.python.org/pypi/zope.exceptions";
      license = "ZPL 2.1";
    };
  };


  "plone.app.users-1.2a2" = self.buildPythonPackage {
    name = "plone.app.users-1.2a2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.users/plone.app.users-1.2a2.zip";
        md5 = "a96e42e34d97162363cb3bbc8483d2ba";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."five.formlib-1.0.4" self."plone.app.controlpanel-2.3.7" self."plone.app.layout-2.3.7" self."plone.protect-2.0.2" self."Products.CMFCore-2.2.7" self."Products.CMFDefault-2.2.3" self."Products.statusmessages-4.0" self.setuptools self."ZODB3-3.10.5" self."zope.component__zcml-3.9.5" self."zope.formlib-4.0.6" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.schema-4.2.2" self."zope.site-3.9.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        A package for all things users and groups related (specific to plone)
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.users";
      license = "GPL version 2";
    };
  };


  "plone.app.caching-1.1.6" = self.buildPythonPackage {
    name = "plone.app.caching-1.1.6";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.caching/plone.app.caching-1.1.6.zip";
        md5 = "52f817d67e6da1508bf6f1486e5466d2";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."plone.app.registry-1.2.3" self."plone.app.z3cform-0.7.4" self."plone.cachepurging-1.0.4" self."plone.caching-1.0" self."plone.memoize-1.1.1" self."plone.protect-2.0.2" self."plone.registry-1.0.1" self."Products.CMFCore-2.2.7" self."Products.CMFDynamicViewFTI-4.0.5" self."Products.GenericSetup-1.7.4" self."Products.statusmessages-4.0" self."python-dateutil-1.5" self.setuptools self."z3c.form-3.0.2" self."z3c.zcmlhook-1.0b1" self."zope.browserresource-3.10.3" self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."zope.pagetemplate-3.6.3" self."zope.publisher-3.12.6" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Plone UI and default rules for plone.caching/z3c.caching
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.caching";
      license = "GPL version 2";
    };
  };


  "AccessControl-3.0.8" = self.buildPythonPackage {
    name = "AccessControl-3.0.8";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/A/AccessControl/AccessControl-3.0.8.zip";
        md5 = "06bea3be59d1ce76c815661180b7ffd9";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."DateTime-3.0.3" self."ExtensionClass-2.13.2" self."Persistence-2.13.2" self."Record-2.13.0" self."RestrictedPython-3.6.0" self."transaction-1.1.1" self."zExceptions-2.13.0" self."ZODB3-3.10.5" self."zope.component__zcml-3.9.5" self."zope.configuration-3.7.4" self."zope.deferredimport-3.5.3" self."zope.interface-3.6.7" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.security__untrustedpython-3.7.4" self."zope.testing-3.9.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Security framework for Zope2.
        '';
      homepage = "http://pypi.python.org/pypi/AccessControl";
      license = "ZPL 2.1";
    };
  };


  "Record-2.13.0" = self.buildPythonPackage {
    name = "Record-2.13.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/R/Record/Record-2.13.0.zip";
        md5 = "cfed6a89d4fb2c9cb995e9084c3071b7";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."ExtensionClass-2.13.2" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Special Record objects used in Zope2.
        '';
      homepage = "http://pypi.python.org/pypi/Record";
      license = "ZPL 2.1";
    };
  };


  "z3c.form-3.0.2" = self.buildPythonPackage {
    name = "z3c.form-3.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/z3c.form/z3c.form-3.0.2.zip";
        md5 = "8eab166766c6ae2e44e40f54136b3f79";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."six-1.2.0" self."zope.browser-1.3" self."zope.browserpage-3.12.2" self."zope.browserresource-3.10.3" self."zope.component__zcml-3.9.5" self."zope.configuration-3.7.4" self."zope.contentprovider-3.7.2" self."zope.event-3.5.2" self."zope.i18n__zcml-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.location-3.9.1" self."zope.pagetemplate-3.6.3" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.security__untrustedpython-3.7.4" self."zope.site-3.9.2" self."zope.traversing-3.13.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        An advanced form and widget framework for Zope 3
        '';
      homepage = "https://launchpad.net/z3c.form";
      license = "ZPL 2.1";
    };
  };


  "Products.CMFPlacefulWorkflow-1.5.9" = self.buildPythonPackage {
    name = "Products.CMFPlacefulWorkflow-1.5.9";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.CMFPlacefulWorkflow/Products.CMFPlacefulWorkflow-1.5.9.zip";
        md5 = "9041e1f52eab5b348c0dfa85be438722";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Products.CMFCore-2.2.7" self."Products.CMFPlone-4.3.2" self."Products.GenericSetup-1.7.4" self."Products.PloneTestCase-0.9.17" self.setuptools self."zope.component__zcml-3.9.5" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.testing-3.9.7" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Workflow policies for CMF and Plone
        '';
      homepage = "http://pypi.python.org/pypi/Products.CMFPlacefulWorkflow";
      license = "GPL";
    };
  };


  "plone.app.textfield-1.2.2" = self.buildPythonPackage {
    name = "plone.app.textfield-1.2.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.textfield/plone.app.textfield-1.2.2.zip";
        md5 = "f832887a40826d6f68c48b48f071fb9c";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."ZODB3-3.10.5" self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."zope.schema-4.2.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Text field with MIME type support
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.textfield";
      license = "GPL";
    };
  };


  "pyquery-1.2.6" = self.buildPythonPackage {
    name = "pyquery-1.2.6";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/pyquery/pyquery-1.2.6.zip";
        md5 = "af51aa835f24eef06175c48dc1218029";
    };
    doCheck = true;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."cssselect-0.9" self."lxml-3.2.3" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        A jquery-like library for python
        '';
      homepage = "https://github.com/gawel/pyquery";
      license = "BSD";
    };
  };


  "zope.event-3.5.2" = self.buildPythonPackage {
    name = "zope.event-3.5.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.event/zope.event-3.5.2.tar.gz";
        md5 = "6e8af2a16157a74885d4f0d88137cefb";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Very basic event publishing system
        '';
      homepage = "http://pypi.python.org/pypi/zope.event";
      license = "ZPL 2.1";
    };
  };


  "initgroups-2.13.0" = self.buildPythonPackage {
    name = "initgroups-2.13.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/i/initgroups/initgroups-2.13.0.zip";
        md5 = "38e842dcab8445f65e701fec75213acd";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Convenience uid/gid helper function used in Zope2.
        '';
      homepage = "http://pypi.python.org/pypi/initgroups";
      license = "ZPL 2.1";
    };
  };


  "zdaemon-2.0.7" = self.buildPythonPackage {
    name = "zdaemon-2.0.7";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zdaemon/zdaemon-2.0.7.tar.gz";
        md5 = "291a875f82e812110557eb6704af8afe";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."ZConfig-2.9.1" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Daemon process control library and tools for Unix-based systems
        '';
      homepage = "http://www.python.org/pypi/zdaemon";
      license = "ZPL 2.1";
    };
  };


  "plone.alterego-1.0" = self.buildPythonPackage {
    name = "plone.alterego-1.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.alterego/plone.alterego-1.0.zip";
        md5 = "b7b6dbcbba00505d98d5aba83e016408";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Low level support for dynamic modules
        '';
      homepage = "http://code.google.com/p/dexterity";
      license = "LGPL";
    };
  };


  "z3c.zcmlhook-1.0b1" = self.buildPythonPackage {
    name = "z3c.zcmlhook-1.0b1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/z3c.zcmlhook/z3c.zcmlhook-1.0b1.tar.gz";
        md5 = "7b6c80146f5930409eb0b355ddf3daeb";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.component__zcml-3.9.5" self."zope.configuration-3.7.4" self."zope.interface-3.6.7" self."zope.schema-4.2.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Easily hook into the ZCML processing machinery
        '';
      homepage = "UNKNOWN";
      license = "ZPL";
    };
  };


  "zope.authentication-3.7.1" = self.buildPythonPackage {
    name = "zope.authentication-3.7.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.authentication/zope.authentication-3.7.1.zip";
        md5 = "7d6bb340610518f2fc71213cfeccda68";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.browser-1.3" self."zope.component__zcml-3.9.5" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.schema-4.2.2" self."zope.security__untrustedpython-3.7.4" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Definition of authentication basics for the Zope Framework
        '';
      homepage = "http://pypi.python.org/pypi/zope.authentication";
      license = "ZPL 2.1";
    };
  };


  "eggtestinfo-0.3" = self.buildPythonPackage {
    name = "eggtestinfo-0.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/e/eggtestinfo/eggtestinfo-0.3.tar.gz";
        md5 = "6f0507aee05f00c640c0d64b5073f840";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Add test information to .egg-info
        '';
      homepage = "http://pypi.python.org/pypi/eggtestinfo";
      license = "PSF or ZPL";
    };
  };


  "plone.portlet.collection-2.1.5" = self.buildPythonPackage {
    name = "plone.portlet.collection-2.1.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.portlet.collection/plone.portlet.collection-2.1.5.zip";
        md5 = "065f0d9141860229cf66d0ff2ed6d4ea";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.app.form-2.2.3" self."plone.app.portlets-2.4.5" self."plone.app.vocabularies-2.1.11" self."plone.memoize-1.1.1" self."plone.portlets-2.2" self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        A portlet that fetches results from a collection
        '';
      homepage = "http://pypi.python.org/pypi/plone.portlet.collection";
      license = "GPL version 2";
    };
  };


  "zope.browser-1.3" = self.buildPythonPackage {
    name = "zope.browser-1.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.browser/zope.browser-1.3.zip";
        md5 = "4ff0ddbf64c45bfcc3189e35f4214ded";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Shared Zope Toolkit browser components
        '';
      homepage = "http://pypi.python.org/pypi/zope.browser";
      license = "ZPL 2.1";
    };
  };


  "plone.app.collection-1.0.11" = self.buildPythonPackage {
    name = "plone.app.collection-1.0.11";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.collection/plone.app.collection-1.0.11.zip";
        md5 = "3f97abc0cd5e370c4bbb1a73f7ee05a7";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."archetypes.querywidget-1.0.9" self."plone.app.contentlisting-1.0.5" self."plone.app.form-2.2.3" self."plone.app.portlets-2.4.5" self."plone.app.vocabularies-2.1.11" self."plone.portlet.collection-2.1.5" self."plone.portlets-2.2" self."Products.Archetypes-1.9.4" self."Products.CMFCore-2.2.7" self."Products.CMFQuickInstallerTool-3.0.6" self."Products.validation-2.0" self.setuptools self."transaction-1.1.1" self."zope.component__zcml-3.9.5" self."zope.configuration-3.7.4" self."zope.formlib-4.0.6" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.schema-4.2.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        This package adds 'saved search' functionality to Plone.
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.collection";
      license = "GPL version 2";
    };
  };


  "Products.CMFCalendar-2.2.2" = self.buildPythonPackage {
    name = "Products.CMFCalendar-2.2.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.CMFCalendar/Products.CMFCalendar-2.2.2.tar.gz";
        md5 = "49458e68dc3b6826ea9a3576ac014419";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."Products.CMFCore-2.2.7" self."Products.CMFDefault-2.2.3" self."Products.GenericSetup-1.7.4" self.setuptools self."Zope2-2.13.21" self."eggtestinfo-0.3" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Calendar product for the Zope Content Management Framework
        '';
      homepage = "http://pypi.python.org/pypi/Products.CMFCalendar";
      license = "ZPL 2.1 (http://www.zope.org/Resources/License/ZPL-2.1)";
    };
  };


  "Products.PluggableAuthService-1.10.0" = self.buildPythonPackage {
    name = "Products.PluggableAuthService-1.10.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.PluggableAuthService/Products.PluggableAuthService-1.10.0.tar.gz";
        md5 = "1a1db6b1d9dd34f8b93a8a3104385a37";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."Products.GenericSetup-1.7.4" self."Products.PluginRegistry-1.3" self.setuptools self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Pluggable Zope2 authentication / authorization framework
        '';
      homepage = "http://pypi.python.org/pypi/Products.PluggableAuthService";
      license = "ZPL 2.1 (http://www.zope.org/Resources/License/ZPL-2.1)";
    };
  };


  "wicked-1.1.10" = self.buildPythonPackage {
    name = "wicked-1.1.10";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/w/wicked/wicked-1.1.10.zip";
        md5 = "f65611f11d547d7dc8e623bf87d3929d";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.container-3.11.2" self."zope.lifecycleevent-3.6.2" self."zope.schema-4.2.2" self."zope.traversing-3.13.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        wicked is a compact syntax for doing wiki-like content linking and creation in zope and plone
        '';
      homepage = "http://pypi.python.org/pypi/wicked";
      license = "GPL";
    };
  };


  "Products.GenericSetup-1.7.4" = self.buildPythonPackage {
    name = "Products.GenericSetup-1.7.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.GenericSetup/Products.GenericSetup-1.7.4.tar.gz";
        md5 = "f93251ed519e8c4aea0bc001416027b1";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."five.localsitemanager-2.0.5" self.setuptools self."zope.formlib-4.0.6" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Read Zope configuration state from profile dirs / tarballs
        '';
      homepage = "http://pypi.python.org/pypi/Products.GenericSetup";
      license = "ZPL 2.1 (http://www.zope.org/Resources/License/ZPL-2.1)";
    };
  };


  "plone.app.viewletmanager-2.0.4" = self.buildPythonPackage {
    name = "plone.app.viewletmanager-2.0.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.viewletmanager/plone.app.viewletmanager-2.0.4.zip";
        md5 = "565a12ac71d20b2823b9e44daebe432f";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."plone.app.vocabularies-2.1.11" self."Products.GenericSetup-1.7.4" self.setuptools self."ZODB3-3.10.5" self."zope.component__zcml-3.9.5" self."zope.contentprovider-3.7.2" self."zope.interface-3.6.7" self."zope.site-3.9.2" self."zope.viewlet-3.7.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        configurable viewlet manager
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.viewletmanager";
      license = "GPL version 2";
    };
  };


  "plone.schemaeditor-1.3.3" = self.buildPythonPackage {
    name = "plone.schemaeditor-1.3.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.schemaeditor/plone.schemaeditor-1.3.3.zip";
        md5 = "25a04a0bf6cd6411669dd3850a1d04b8";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.autoform-1.5" self."plone.z3cform-0.8.0" self.setuptools self."z3c.form-3.0.2" self."zope.component__zcml-3.9.5" self."zope.container-3.11.2" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Provides through-the-web editing of a zope schema/interface.
        '';
      homepage = "http://svn.plone.org/svn/plone/plone.schemaeditor";
      license = "BSD";
    };
  };


  "zope.structuredtext-3.5.1" = self.buildPythonPackage {
    name = "zope.structuredtext-3.5.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.structuredtext/zope.structuredtext-3.5.1.tar.gz";
        md5 = "eabbfb983485d0879322bc878d2478a0";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        StructuredText parser
        '';
      homepage = "http://pypi.python.org/pypi/zope.structuredtext";
      license = "ZPL 2.1";
    };
  };


  "zope.ramcache-1.0" = self.buildPythonPackage {
    name = "zope.ramcache-1.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.ramcache/zope.ramcache-1.0.zip";
        md5 = "87289e15f0e51f50704adda1557c02a7";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."ZODB3-3.10.5" self."zope.interface-3.6.7" self."zope.location-3.9.1" self."zope.testing-3.9.7" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Zope RAM Cache
        '';
      homepage = "http://pypi.python.org/pypi/zope.ramcache";
      license = "ZPL 2.1";
    };
  };


  "ZopeUndo-2.12.0" = self.buildPythonPackage {
    name = "ZopeUndo-2.12.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/Z/ZopeUndo/ZopeUndo-2.12.0.zip";
        md5 = "2b8da09d1b98d5558f62e12f6e52c401";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        ZODB undo support for Zope2.
        '';
      homepage = "http://pypi.python.org/pypi/ZopeUndo";
      license = "ZPL 2.1";
    };
  };


  "zope.traversing-3.13.2" = self.buildPythonPackage {
    name = "zope.traversing-3.13.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.traversing/zope.traversing-3.13.2.zip";
        md5 = "eaad8fc7bbef126f9f8616b074ec00aa";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."zope.component__zcml-3.9.5" self."zope.i18n__zcml-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.location-3.9.1" self."zope.proxy-3.6.1" self."zope.publisher-3.12.6" self."zope.security__untrustedpython-3.7.4" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Resolving paths in the object hierarchy
        '';
      homepage = "http://pypi.python.org/pypi/zope.traversing";
      license = "ZPL 2.1";
    };
  };


  "zope.contentprovider-3.7.2" = self.buildPythonPackage {
    name = "zope.contentprovider-3.7.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.contentprovider/zope.contentprovider-3.7.2.tar.gz";
        md5 = "1bb2132551175c0123f17939a793f812";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.component__zcml-3.9.5" self."zope.event-3.5.2" self."zope.interface-3.6.7" self."zope.location-3.9.1" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.tales-3.5.3" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Content Provider Framework for Zope Templates
        '';
      homepage = "http://pypi.python.org/pypi/zope.contentprovider";
      license = "ZPL 2.1";
    };
  };


  "plonetheme.classic-1.3.2" = self.buildPythonPackage {
    name = "plonetheme.classic-1.3.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plonetheme.classic/plonetheme.classic-1.3.2.zip";
        md5 = "c77d4c34afaf7c02df44d4df72328155";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        The classic Plone 3 default theme.
        '';
      homepage = "http://pypi.python.org/pypi/plonetheme.classic";
      license = "GPL version 2";
    };
  };


  "plone.scale__storage-1.3.2" = self.buildPythonPackage {
    name = "plone.scale__storage-1.3.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.scale/plone.scale-1.3.2.zip";
        md5 = "584ccbf515aff9fef363c2cc8abac789";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."Persistence-2.13.2" self."zope.annotation-3.5.0" self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Image scaling
        '';
      homepage = "http://pypi.python.org/pypi/plone.scale";
      license = "BSD";
    };
  };


  "zope.browserpage-3.12.2" = self.buildPythonPackage {
    name = "zope.browserpage-3.12.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.browserpage/zope.browserpage-3.12.2.tar.gz";
        md5 = "a543ef3cb1b42f7233b3fca23dc9ea60";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.component__zcml-3.9.5" self."zope.configuration-3.7.4" self."zope.interface-3.6.7" self."zope.pagetemplate-3.6.3" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.security__untrustedpython-3.7.4" self."zope.traversing-3.13.2" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        ZCML directives for configuring browser views for Zope.
        '';
      homepage = "http://pypi.python.org/pypi/zope.browserpage/";
      license = "ZPL 2.1";
    };
  };


  "plone.app.imaging-1.0.9" = self.buildPythonPackage {
    name = "plone.app.imaging-1.0.9";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.imaging/plone.app.imaging-1.0.9.zip";
        md5 = "e680c5540021a70266343b935ac732a7";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.scale__storage-1.3.2" self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        User-configurable, blob-aware image scaling for Plone.
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.imaging";
      license = "GPL version 2";
    };
  };


  "Products.SecureMailHost-1.1.2" = self.buildPythonPackage {
    name = "Products.SecureMailHost-1.1.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.SecureMailHost/Products.SecureMailHost-1.1.2.zip";
        md5 = "7db0f1fa867bd0df972082f502a7a707";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        SecureMailHost is a reimplementation of the standard Zope2 MailHost with some security and usability enhancements.
        '';
      homepage = "http://svn.plone.org/svn/collective/SecureMailHost/trunk";
      license = "ZPL";
    };
  };


  "plone.portlets-2.2" = self.buildPythonPackage {
    name = "plone.portlets-2.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.portlets/plone.portlets-2.2.zip";
        md5 = "5b7e06bee6e40af83694b82e1fee8c2d";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.memoize-1.1.1" self.setuptools self."ZODB3-3.10.5" self."zope.annotation-3.5.0" self."zope.component__zcml-3.9.5" self."zope.container-3.11.2" self."zope.contentprovider-3.7.2" self."zope.interface-3.6.7" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.site-3.9.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        An extension of zope.viewlet to support dynamic portlets
        '';
      homepage = "http://pypi.python.org/pypi/plone.portlets";
      license = "GPL version 2";
    };
  };


  "archetypes.querywidget-1.0.9" = self.buildPythonPackage {
    name = "archetypes.querywidget-1.0.9";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/a/archetypes.querywidget/archetypes.querywidget-1.0.9.zip";
        md5 = "67e51c20990bb3eefbc9e8e953d7c9f5";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."plone.app.jquerytools-1.5.6" self."plone.app.querystring-1.0.8" self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        UNKNOWN
        '';
      homepage = "http://pypi.python.org/pypi/archetypes.querywidget";
      license = "GPL version 2";
    };
  };


  "Products.PluginRegistry-1.3" = self.buildPythonPackage {
    name = "Products.PluginRegistry-1.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.PluginRegistry/Products.PluginRegistry-1.3.tar.gz";
        md5 = "5b166193ca1eb84dfb402051f779ebab";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."Products.GenericSetup-1.7.4" self.setuptools self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Configure application plugins based on interfaces
        '';
      homepage = "http://pypi.python.org/pypi/Products.PluginRegistry";
      license = "ZPL 2.1 (http://www.zope.org/Resources/License/ZPL-2.1)";
    };
  };


  "repoze.xmliter-0.5" = self.buildPythonPackage {
    name = "repoze.xmliter-0.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/r/repoze.xmliter/repoze.xmliter-0.5.zip";
        md5 = "99da76bcbad6fbaced4a273bde29b10e";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."lxml-2.3.6" self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Wrapper for ``lxml`` trees which serializes to string upon iteration.
        '';
      homepage = "http://www.repoze.org";
      license = "BSD-derived (http://www.repoze.org/LICENSE.txt)";
    };
  };


  "zLOG-2.11.1" = self.buildPythonPackage {
    name = "zLOG-2.11.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zLOG/zLOG-2.11.1.tar.gz";
        md5 = "68073679aaa79ac5a7b6a5c025467147";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."ZConfig-2.9.1" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        A general logging facility
        '';
      homepage = "http://cheeseshop.python.org/pypi/zLOG";
      license = "ZPL 2.1";
    };
  };


  "zope.location-3.9.1" = self.buildPythonPackage {
    name = "zope.location-3.9.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.location/zope.location-3.9.1.tar.gz";
        md5 = "1684a8f986099d15296f670c58e713d8";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.component__zcml-3.9.5" self."zope.interface-3.6.7" self."zope.proxy-3.6.1" self."zope.schema-4.2.2" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Zope Location
        '';
      homepage = "http://pypi.python.org/pypi/zope.location/";
      license = "ZPL 2.1";
    };
  };


  "experimental.cssselect-0.3" = self.buildPythonPackage {
    name = "experimental.cssselect-0.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/e/experimental.cssselect/experimental.cssselect-0.3.zip";
        md5 = "3fecdcf1fbc3ea6025e115a56a262957";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."lxml-2.3.6" self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Experimental version of lxml.cssselect
        '';
      homepage = "https://github.com/lrowe/experimental.cssselect";
      license = "UNKNOWN";
    };
  };


  "zope.formlib-4.0.6" = self.buildPythonPackage {
    name = "zope.formlib-4.0.6";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.formlib/zope.formlib-4.0.6.zip";
        md5 = "eed9c94382d11a4dececd0a48ac1d3f2";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."pytz-2013b" self.setuptools self."zope.browser-1.3" self."zope.browserpage-3.12.2" self."zope.component__zcml-3.9.5" self."zope.datetime-3.4.1" self."zope.event-3.5.2" self."zope.i18n__zcml-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.security__untrustedpython-3.7.4" self."zope.traversing-3.13.2" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Form generation and validation library for Zope
        '';
      homepage = "http://pypi.python.org/pypi/zope.formlib";
      license = "ZPL 2.1";
    };
  };


  "zope.copy-3.5.0" = self.buildPythonPackage {
    name = "zope.copy-3.5.0";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.copy/zope.copy-3.5.0.tar.gz";
        md5 = "a9836a5d36cd548be45210eb00407337";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."zope.interface-3.6.7" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Pluggable object copying mechanism
        '';
      homepage = "http://pypi.python.org/pypi/zope.copy";
      license = "ZPL 2.1";
    };
  };


  "plone.subrequest-1.6.7" = self.buildPythonPackage {
    name = "plone.subrequest-1.6.7";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.subrequest/plone.subrequest-1.6.7.zip";
        md5 = "cc12f68a22565415b10dbeef0020baa4";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."five.globalrequest-1.0" self.setuptools self."zope.globalrequest-1.0" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Subrequests for Zope2
        '';
      homepage = "http://pypi.python.org/pypi/plone.subrequest/";
      license = "GPL version 2";
    };
  };


  "plone.app.vocabularies-2.1.11" = self.buildPythonPackage {
    name = "plone.app.vocabularies-2.1.11";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.vocabularies/plone.app.vocabularies-2.1.11.tar.gz";
        md5 = "08c773a5093780aaa27709a890f1e21f";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self."Products.CMFCore-2.2.7" self.setuptools self."zope.browser-1.3" self."zope.component__zcml-3.9.5" self."zope.formlib-4.0.6" self."zope.i18n__zcml-3.7.4" self."zope.i18nmessageid-3.5.3" self."zope.interface-3.6.7" self."zope.schema-4.2.2" self."zope.site-3.9.2" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        A collection of generally useful vocabularies.
        '';
      homepage = "https://github.com/plone/plone.app.vocabularies";
      license = "GPL version 2";
    };
  };


  "DocumentTemplate-2.13.2" = self.buildPythonPackage {
    name = "DocumentTemplate-2.13.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/D/DocumentTemplate/DocumentTemplate-2.13.2.zip";
        md5 = "07bb086c77c1dfe94125ad2efbba94b7";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."AccessControl-3.0.8" self."Acquisition-2.13.8" self."ExtensionClass-2.13.2" self."RestrictedPython-3.6.0" self."zExceptions-2.13.0" self."zope.sequencesort-3.4.0" self."zope.structuredtext-3.5.1" ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Document Templating Markup Language (DTML)
        '';
      homepage = "http://pypi.python.org/pypi/DocumentTemplate";
      license = "ZPL 2.1";
    };
  };


  "plone.registry-1.0.1" = self.buildPythonPackage {
    name = "plone.registry-1.0.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.registry/plone.registry-1.0.1.zip";
        md5 = "6be3d2ec7e2d170e29b8c0bc65049aff";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools self."ZODB3-3.10.5" self."zope.component__zcml-3.9.5" self."zope.dottedname-3.4.6" self."zope.event-3.5.2" self."zope.interface-3.6.7" self."zope.schema-4.2.2" self."zope.testing-3.9.7" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        A debconf-like (or about:config-like) registry for storing application settings
        '';
      homepage = "http://pypi.python.org/pypi/plone.registry";
      license = "GPL";
    };
  };


  "Products.ExtendedPathIndex-3.1" = self.buildPythonPackage {
    name = "Products.ExtendedPathIndex-3.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.ExtendedPathIndex/Products.ExtendedPathIndex-3.1.zip";
        md5 = "00c048a4b103200bdcbda61fa22c66df";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."AccessControl-3.0.8" self.setuptools self."transaction-1.1.1" self."ZODB3-3.10.5" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Zope catalog index for paths
        '';
      homepage = "http://pypi.python.org/pypi/Products.ExtendedPathIndex";
      license = "GPL version 2";
    };
  };


  "zope.i18nmessageid-3.5.3" = self.buildPythonPackage {
    name = "zope.i18nmessageid-3.5.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.i18nmessageid/zope.i18nmessageid-3.5.3.tar.gz";
        md5 = "cb84bf61c2b7353e3b7578057fbaa264";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Message Identifiers for internationalization
        '';
      homepage = "http://pypi.python.org/pypi/zope.i18nmessageid";
      license = "ZPL 2.1";
    };
  };


  "plone.app.linkintegrity-1.5.3" = self.buildPythonPackage {
    name = "plone.app.linkintegrity-1.5.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.app.linkintegrity/plone.app.linkintegrity-1.5.3.zip";
        md5 = "f2eed92f433fe73b4056d3ba48ba8eb0";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Manage link integrity in Plone.
        '';
      homepage = "http://pypi.python.org/pypi/plone.app.linkintegrity";
      license = "GPL version 2";
    };
  };


  "Products.CMFActionIcons-2.1.3" = self.buildPythonPackage {
    name = "Products.CMFActionIcons-2.1.3";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/P/Products.CMFActionIcons/Products.CMFActionIcons-2.1.3.tar.gz";
        md5 = "ab1dc62404ed11aea84dc0d782b2235e";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self."Products.CMFCore-2.2.7" self."Products.GenericSetup-1.7.4" self.setuptools self."eggtestinfo-0.3" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Action icons product for the Zope Content Management Framework
        '';
      homepage = "http://pypi.python.org/pypi/Products.CMFActionIcons";
      license = "ZPL 2.1 (http://www.zope.org/Resources/License/ZPL-2.1)";
    };
  };


  "zope.app.form-4.0.2" = self.buildPythonPackage {
    name = "zope.app.form-4.0.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/z/zope.app.form/zope.app.form-4.0.2.tar.gz";
        md5 = "3d2b164d9d37a71490a024aaeb412e91";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [ self.setuptools self."transaction-1.1.1" self."zope.browser-1.3" self."zope.browsermenu-3.9.1" self."zope.browserpage-3.12.2" self."zope.component__zcml-3.9.5" self."zope.configuration-3.7.4" self."zope.datetime-3.4.1" self."zope.exceptions-3.6.2" self."zope.formlib-4.0.6" self."zope.i18n__zcml-3.7.4" self."zope.interface-3.6.7" self."zope.proxy-3.6.1" self."zope.publisher-3.12.6" self."zope.schema-4.2.2" self."zope.security__untrustedpython-3.7.4" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        The Original Zope 3 Form Framework
        '';
      homepage = "http://pypi.python.org/pypi/zope.app.form";
      license = "ZPL 2.1";
    };
  };


  "five.localsitemanager-2.0.5" = self.buildPythonPackage {
    name = "five.localsitemanager-2.0.5";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/f/five.localsitemanager/five.localsitemanager-2.0.5.zip";
        md5 = "5e3a658e6068832bd802018ebc83f2d4";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Acquisition-2.13.8" self.setuptools self."ZODB3-3.10.5" self."zope.component__zcml-3.9.5" self."zope.event-3.5.2" self."zope.interface-3.6.7" self."zope.lifecycleevent-3.6.2" self."zope.location-3.9.1" self."zope.site-3.9.2" self."zope.testing-3.9.7" self."Zope2-2.13.21" ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Local site manager implementation for Zope 2
        '';
      homepage = "http://pypi.python.org/pypi/five.localsitemanager";
      license = "ZPL 2.1";
    };
  };


  "plone.outputfilters-1.11.1" = self.buildPythonPackage {
    name = "plone.outputfilters-1.11.1";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/p/plone.outputfilters/plone.outputfilters-1.11.1.zip";
        md5 = "6b7506f09ad98621f8bb388c55183d6d";
    };
    doCheck = false;
    buildInputs = [ pkgs.unzip ];
    propagatedBuildInputs = [ self."Products.CMFCore-2.2.7" self."Products.GenericSetup-1.7.4" self."Products.MimetypesRegistry-2.0.5" self."Products.PortalTransforms-2.1.2" self.setuptools ];
    installCommand = ''easy_install --always-unzip --no-deps --prefix="$out" .'';
    meta = {
      description = ''
        Transformations applied to HTML in Plone text fields as they are rendered
        '';
      homepage = "http://github.com/plone/plone.outputfilters";
      license = "GPL";
    };
  };


  "xlrd" = self."xlrd-0.9.2";

  "xlrd-0.9.2" = self.buildPythonPackage {
    name = "xlrd-0.9.2";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/x/xlrd/xlrd-0.9.2.tar.gz";
        md5 = "91a81ee76233e9f3115acaaa1b251b0e";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Library for developers to extract data from Microsoft Excel (tm) spreadsheet files
        '';
      homepage = "http://www.python-excel.org/";
      license = "BSD";
    };
  };


  "suds" = self."suds-0.4";

  "suds-0.4" = self.buildPythonPackage {
    name = "suds-0.4";
    src = fetchurl {
        url = "https://pypi.python.org/packages/source/s/suds/suds-0.4.tar.gz";
        md5 = "b7502de662341ed7275b673e6bd73191";
    };
    doCheck = false;
    buildInputs = [  ];
    propagatedBuildInputs = [  ];
    installCommand = ''easy_install --always-unzip --prefix="$out" .'';
    meta = {
      description = ''
        Lightweight SOAP client
        '';
      homepage = "https://fedorahosted.org/suds";
      license = "UNKNOWN";
    };
  };

}

