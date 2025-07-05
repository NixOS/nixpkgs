{
  lib,
  stdenv,
  aiobotocore,
  boto3,
  botocore,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;
  buildTypesAiobotocorePackage =
    serviceName: version: hash:
    buildPythonPackage rec {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      pyproject = true;

      disabled = pythonOlder "3.7";

      oldStylePackages = [
        "gamesparks"
        "iot-roborunner"
        "macie"
      ];

      src = fetchPypi {
        pname =
          if builtins.elem serviceName oldStylePackages then
            "types-aiobotocore-${serviceName}"
          else
            "types_aiobotocore_${toUnderscore serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [
        aiobotocore
        boto3
        botocore
      ] ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

      # Module has no tests
      doCheck = false;

      pythonImportsCheck = [ "types_aiobotocore_${toUnderscore serviceName}" ];

      meta = with lib; {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = licenses.mit;
        maintainers = with maintainers; [ mbalatsko ];
      };
    };
in
{
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "2.23.0"
      "sha256-cS+J8HbeXIeuwnehVZhZcf0Rs1kIpv9Iq40wpGxCjZQ=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "2.23.0"
      "sha256-2MBVTwsQFmCB4CmiDceMHiZot4fvA24dXy0dZfsvfQk=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "2.23.0"
      "sha256-jMIO9W9fFFYpH6rox9J7Z7Kdfo3abqyJf4IHLC8+WEU=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "2.23.0"
      "sha256-DlJWWBGo8Cs7ckoO0eeaqH8CXgY865XyC2lbyjvkMP4=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "2.23.0"
      "sha256-LUWusWWWULisXSUfhbWBTCJV3rdRIl9wNNS3k/dOabk=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "2.23.0"
      "sha256-XysWv97shKhHnR0RkQlp7xFkgbnPvggISq11Z1q+lm0=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "2.23.0"
      "sha256-kzmW0BodY0L4Zb0FSb1GeC/zwTKtPitwkJswv6FwOKM=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "2.23.0"
      "sha256-Vwrx+ziBTuzE+Nsj0JJ3AQK1wuL2CD74lWFBrvYxELg=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "2.23.0"
      "sha256-w130/4oOM90v9CKZE+HsTR7tu2iJgyaJrflSgte8S/U=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.23.0"
      "sha256-5Q0UF0ZwLJB6DDXebVZfayGMg38l/XF2lmW79wrQhKo=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "2.23.0"
      "sha256-tFJ9O4tEk3YvljqrIRI4LtEfpC7zw12elSLBNRGt8Ds=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "2.23.0"
      "sha256-fMKdwRLLlQzj+gyvDctJPJ4LXzZoQeZqAwUg3bFPK9I=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "2.23.0"
      "sha256-WftvoVqdnBvnpKI3UfgO4iKpRzESS5viWARYlZHKPgM=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "2.23.0"
      "sha256-RTvlGWpu7po3tsRWOAcqyoSZMAaAp/FCjdP06AHaDFk=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "2.23.0"
      "sha256-wh01LXAqR9sJYpo9SVI81H24DhvL5gEhxvocpIPVtZE=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "2.23.0"
      "sha256-Yr4EdA6Wth1WD+7jGV5DpfWJU5K3VeVdWEjpLxP31vM=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "2.23.0"
      "sha256-O0LChGpl/nGTMQfGhgoe7GQ3Y2675C4nmckGW7R3Vw4=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "2.23.0"
      "sha256-cNTyl6Dp5zbirEkA4ik52yTZn/s7Sn0Nni9uz8mJpeU=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "2.23.0"
      "sha256-2C3gATyp0aQwWEvxEcXJDfo2WS9AB0s1AKjLHH3sqnI=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "2.23.0"
      "sha256-fZJzkW4IvoZ0NyiYhuLfnQ0xPXJZxMKBEGUWd0R81yU=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "2.23.0"
      "sha256-7jBpid4+CZNnaykvxQntNamXKto6XwPuShcPKJ90PX4=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "2.23.0"
      "sha256-Pi0WtE/dLlHRXdikkNGZeMovO5e1vAaa383O+FC2rSM=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "2.23.0"
      "sha256-kPzOZSGEHN4V42Kcy5A3cDme83isNQM/8mjtSP4b67Y=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "2.23.0"
      "sha256-FN5PnBnfnYG3VhOpcx/MQSirKAI2Js9PofwnNpphC7s=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "2.23.0"
      "sha256-oou4FeSDKboTCn/y4+h+ufC5vfuoCnHE+9ndFr3fhws=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "2.23.0"
      "sha256-ckF24G+V4dNM2cRMIbebSngFOOt3k6lTv8HVb5W1PVg=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "2.23.0"
      "sha256-6PSt6QUxIFIfB3dLS7m/TKqbiTabW7spAJzWxbO5O4U=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "2.23.0"
      "sha256-D75rq+XqRPDDhlCSdLHVGRsZMTUitD/qAPgqo+TvOmA=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "2.23.0"
      "sha256-/Bunshz/jadAO5wogGw1REHhue3lf6/NptoymgtQSpE=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "2.23.0"
      "sha256-6iy/l0I+MNl+DHGvBnuX2C6llwVY0rpeIABgAnB+/MM=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "2.23.0"
      "sha256-6oa7vcM+WmSgPBawUCbQA+dubg3k4If0AOq65Z57dqE=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "2.23.0"
      "sha256-zSunUJqxfUE6qSiL75+LHTpBnX6Dn/0PEIdj37s1KCI=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "2.23.0"
      "sha256-B/y00g09rTafRgqbTcAjLdjHmai9smsxAelacmaRRrg=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "2.23.0"
      "sha256-MRx6QURiIHTi5bnECUuOByYGAXRf12wcOBblgAdPaf0=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "2.23.0"
      "sha256-V+9t4q7visfTOWqaP3/05wJnaU+qGbjAUu+lK+7lkys=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "2.23.0"
      "sha256-WBFkfq59d+QtT37ITLqLXR1pC4SuTcZLCykHqeQFmAI=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "2.23.0"
      "sha256-DFLEybsE3FtvowGBgVNyAxNRcARoOUk8OuqaEn0nbhQ=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.23.0"
      "sha256-5dnmgHXG6wTZUlHKXCe3XCa1jg+vrFLCZ2c3hyjPBOA=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "2.23.0"
      "sha256-4KLZQurvp7YP6+eKdL+r0K410OfE5MknJ6X9BTPsJN8=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "2.23.0"
      "sha256-j7BUyR72UruaGvKFsQhPK1Oeh1Dpf6EUA55qj1SS0/c=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "2.23.0"
      "sha256-mkpNU955vuEjduNOxDqiXdJac6vBrehKe5oDFw88UU4=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "2.23.0"
      "sha256-5+QvYZb4o+Co108rOe2R+lYpYkjGc5WEBtvBhZAGTDM=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "2.23.0"
      "sha256-qVj5LHoidCu/XJzvwd2L2+Z9TAuFLWZRuGzs4v/oek4=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "2.23.0"
      "sha256-u/7+WOtS/jwJ9IkjgcTVuyOVJy8yL+PwW439oXwD354=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "2.23.0"
      "sha256-/b7fas05oRK6Z3rsjGPzRXmZKIw9Xikxk1zun10MP8g=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "2.23.0"
      "sha256-vCIy5wwMEJaeKiEbj0MENapAXLGYFh8v/nVODe/sJ6k=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "2.23.0"
      "sha256-lPdiaYqQO1tIqUsQVWF24WwPx4fWLrBWWAw1NgeKoV0=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "2.23.0"
      "sha256-zP22D9t5iVxLtVcMawyniz0b3iJ4cZaPhbkAYnSaLow=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "2.23.0"
      "sha256-MamTXVWD/SNhj7wC7CyPnnPCqwO1t0jwjCx2wix37Xg=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "2.23.0"
      "sha256-qDBprAdeu8yVOEd+iiAurPXo16OpCFfkO1+HgatLPXY=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "2.23.0"
      "sha256-hzymjTVHcjciP77O2WhiTUibT+EKBlaAkXY4riVVk1g=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "2.23.0"
      "sha256-BL8c4s8DcSUhR33muBGTU04szDPOXzuadFf6V0TQGBc=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "2.23.0"
      "sha256-AidbcE+KwUtBwznfemUUK8b1O2Kno6VUTgNXliMbO20=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "2.23.0"
      "sha256-oCbmtfImoEF3yL7GzrShRrlTOpy0Fq41Ly5Yd/O9JVc=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "2.23.0"
      "sha256-OsiOTxHF2QVsgL41EyDDoJLCuELFB2kMaLvcuvfmA94=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "2.23.0"
      "sha256-mfuUYBtfr4gtmZ1UXhsvUhFA1UdSLMMnzvJ/VUHTXuE=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "2.23.0"
      "sha256-MZ8pTDqy2NIA8RoeUCGn5pndpW1D0dt7ev9NEMhbH4c=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "2.23.0"
      "sha256-MtRDVJvm5V36RRTEdH6lWLi6y9pENtwISQDuJ/AveIk=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "2.23.0"
      "sha256-n/7woNkODCmcLSTyZy00zyOrMIEYtmWx3RsmSaj5P0c=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "2.23.0"
      "sha256-PRstvOpDP2LymnMgJjmWZEypq5oaS/35a7PSRjeS2rc=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "2.23.0"
      "sha256-ajKNePyhOQbfMVcmI1gHyBWpeamvEg/yuHsEA8bmnYs=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "2.23.0"
      "sha256-kfrbFZgOnX9Fo1Uy0tcLNRf6AfbmFAgmYWR8PAEn1TI=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "2.23.0"
      "sha256-r4M6tdB+NryGkaARn2VR4a8iLK6Wb702TN9EMlpBakk=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "2.23.0"
      "sha256-6TSwPkip3Q36BLUegXY0i8WcnwY7Y6SuS+WYBP7vA9A=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "2.23.0"
      "sha256-KN2fbSKuAao0dz8dMsWPSiXIPR6ehfLeydZkha0WWmc=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "2.23.0"
      "sha256-5TopGeCk5WosTVvDWWLi9hZqqsU5AEA1UG76eGu0JOQ=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "2.23.0"
      "sha256-v4VkTPPyTuVBvGFXDR+NcS5HOUHdzEHNCOimntaGjZI=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "2.23.0"
      "sha256-uOIfzJvAFPFUldEYEQXMmh33x0rSPrDvg6CwF9SSd+U=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "2.23.0"
      "sha256-xBbCQN/u7y0zKgNYqj7JWgh1pcl3wf9gnJvn1wmMDqY=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "2.23.0"
      "sha256-YW31t9hKSLIBCnb/yLTDotN50HvVM3FqXb51sT/DsPI=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "2.23.0"
      "sha256-F0JU93x67j5qjelrX0Z/weeuiiIIlwc7/G9zrq2MSoE=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "2.23.0"
      "sha256-If7e1MHYhTJTb9RrQuCcRAjDBAnc7HV4o3IxEKOdVtA=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "2.23.0"
      "sha256-R5jPd9Kg1Dl8Pcx/Jrvgvjfvq6ZqVdh+KPRP5i1zjc0=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "2.23.0"
      "sha256-Fh0WyhArQ/70mBXbVNoKSYjMyKmxJ8xOL2DN5jWxZfg=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "2.23.0"
      "sha256-w820rXafEeQ1KliyI/goabJYqJHUED2DkZG8lgnBFYs=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "2.23.0"
      "sha256-JWrOhYj4W99nOYNjWLvPzXJBiF6ekBHjEyoB42A9D9Y=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "2.23.0"
      "sha256-kX7z11MmwithX2cROUrtTXWD2Qhc7f6X4KhF51U+qPQ=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "2.23.0"
      "sha256-hBzpjsgESRkdF4GZD5WJI35W7Hq3Zhbg+mFYTUoKYv4=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "2.23.0"
      "sha256-e4TQ7E12PIhSgs1j1WLqsgbadLQSwD1FvnJZT738xA8=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "2.23.0"
      "sha256-QHS9rXfa30kFdCJIdWEsEpX2JnmpqV9zjn9tO3vA+b0=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "2.23.0"
      "sha256-4JZU5FLs+wlWgfWLeuL1EKmQ9OvvNIP+B/CXI61FFqQ=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "2.23.0"
      "sha256-KCH76RQkVmcpy82gezMCmr5U8SeVIIe+34cMBxPLE88=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "2.23.0"
      "sha256-PGVr+VCGWbzB2S2S1lCpDnq5Fgi9CD7MfL4BNOgIbVo=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "2.23.0"
      "sha256-fQT80IRjXads6i8frHClHpVLigUCIbDuMsEWN8p/nec=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "2.23.0"
      "sha256-0JNhybCcxin8L5zKIvUOa7Hz/sFP6fyS37pJOVRg7uM=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "2.23.0"
      "sha256-1IztA7tbbNl65DIxfUO1fpt5uh+Y6Tm+XsHsVtVLROs=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "2.23.0"
      "sha256-KxIRqxTRmlKzXPS2ISB7oPWwz4I6tWOOeoeVniUoDAU=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "2.23.0"
      "sha256-Nx/a/iOCLKDARXjGGyEGm+OleqinDsd4voo/5wjK5K0=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "2.23.0"
      "sha256-088DIKzTjLnFkmJAVI0PhPf1r652bE4A8VChKTY4V0I=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "2.23.0"
      "sha256-gC80zfdT8O0HCJweW2GpohHdQOTHgEIPodX32M3kwc8=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "2.23.0"
      "sha256-ykFJ7H2ICW3B1Tpolm0/eYgLWbeB0P2lRYqUEgI1chY=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "2.23.0"
      "sha256-fzujBchonm8xu/ZSponndemKobzx9sXOa5v42AimYAw=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "2.23.0"
      "sha256-Me4CHV0xFSfkGy/QtliaxEcHUqS0HbdeD/iiWlixBB0=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "2.23.0"
      "sha256-hm/4u9QNr8GqJw82Mf2G7b9c7s+dZN+ZuToLmsY4HAs=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "2.23.0"
      "sha256-i/JXq7xCBRGZzB+IUu7uGyFSAxIoAFCCbRBwwxEMG1k=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "2.23.0"
      "sha256-Cz6bHKmnoBDx1qUwwhCbG7HV5vrgPUYpqIM6Io4CEvQ=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "2.23.0"
      "sha256-El7/S1j+QCemtzqKTrlb9UByWCySi34BqGKBgHq/TUY=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "2.23.0"
      "sha256-q0+Zx9Bh97kOMsRzQF4eXO8JBK/CmieoTkizbafMezY=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "2.23.0"
      "sha256-xrVlGlxpxwqN2EoscCdYz5tceU4MJdtkPxU+beCCK20=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "2.23.0"
      "sha256-ZUSHk1xLQeN2pgCuJ+FV19jzuptF92Wft7cxwL+TbGc=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "2.23.0"
      "sha256-6yYk2uReu/MRd6QrrvevoCf9CU99x+u1ClWjYo0BpGk=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "2.23.0"
      "sha256-ojnl/x2DCEf3RFvSBt2QZEAgV6JnI2z5ofTed+/u+CQ=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "2.23.0"
      "sha256-X/3X+A5Dh8tku3Pz1GrgtvQVQUaTyVAoULFvqqn+AuI=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "2.23.0"
      "sha256-kDuIuxTai2HxzpZoJ/pTSYFIVLmRHqGuUmgzB0SjCcw=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "2.23.0"
      "sha256-p6JNHivU9kKGM7uixi6O2tLNrewE4id+D4I+al1UZcM=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "2.23.0"
      "sha256-jv087z12Afqxq8b+RvYHwv5daAmqMHF0Urv+TRVP2MA=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "2.23.0"
      "sha256-FhHvMwl7a40xwQOAihsxTmUYVu5RNh75WNtkSZaiMP0=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "2.23.0"
      "sha256-eJc3li/5tA7x2MF50JtKwIgvZQAe6MzjPbyILACjMAM=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.23.0"
      "sha256-FdmufFcmdsly4x4q28W0xLZownb7sWVq6PN0OlLoEkc=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "2.23.0"
      "sha256-SL2VeHPDoO1RBxXLcFOgBVmJUy/lNJ9U/WKQ1fpr0JA=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "2.23.0"
      "sha256-PgSGKPbGFPpYUc3Bg+YuvwJGqD6GcFtH1NcRz5H6URc=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "2.23.0"
      "sha256-y5lRhpsnTPxZtCTjXSEcgCDgu2k7x2i4mJGWelS/e6A=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "2.23.0"
      "sha256-eUgGa57kwrUnh1WdQ5L+EN7H8h60oRR1onOmgSPYm6E=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "2.23.0"
      "sha256-l9gt0S1we7yxFzSPUaGSC29fx3vfoSS5a4WbDgWTnzw=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "2.23.0"
      "sha256-7brVNVDslbaEozCIFMK7oeGpnRyhQaFpOob9NLFdSMo=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "2.23.0"
      "sha256-9ZPJg1t597k9Tpy4SJ4cf2rcYfqwqAe4tqLspPL4GfM=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "2.23.0"
      "sha256-V7xAEvjsxXy4s5s+D7crWsMfHtr5VRD/pSzoIlMM+bk=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "2.23.0"
      "sha256-HI7Z23JYXH/9Bn41Qw7lf+sPCfNdfFH4+pLCsO46olE=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "2.23.0"
      "sha256-DhVVpXH6kEfkg5fe7ttJ2ENcnBqt2y86C8w/g0da2xA=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "2.23.0"
      "sha256-FLCcuwox7YMeo0JQNb/LEFX346jR09PqBA6frgL2Rh8=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "2.23.0"
      "sha256-Jdd648Uxx6XEF0778qzO5NmJbaQCbC8YJtDwwckvAH4=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "2.23.0"
      "sha256-wGcjFbyVNz/YWwlMgNxZ19iXdhHC3QLRZ6XzXcEvRts=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "2.23.0"
      "sha256-ktGUlV/5vmtEbOXeq9B9R0caclKr6VCvLK9NbEjPV64=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "2.23.0"
      "sha256-cM63AZvUHqZhpVEkbpRPp8F1fUWss18g5eQcjhB4m8M=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "2.23.0"
      "sha256-kQ2Wm+REoWDBNdtZ66We191OeE3TU2RVntbxLGJFjaw=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "2.23.0"
      "sha256-bgi31NDCGqou8qsBlwyYGrMVxXMcqHLcHJoOducHBR4=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "2.23.0"
      "sha256-1IQxbug2+0wm84UUOABWcMuTaOtKwYTqubRZb25oSto=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "2.23.0"
      "sha256-rHdo/BlkupWamldLTadXNIV3d0chN+EFxHZfMdvygxg=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "2.23.0"
      "sha256-1/mYk49KxCANignx36iHd5NlwZDMdvOVG6xN3+GxxOc=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "2.23.0"
      "sha256-NUDKXV8htnNOkQpHcg0UvhblK2/btHDahAf9TxWbKo8=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "2.23.0"
      "sha256-/HSxR2J2LI4SlaQL4Xj8GnLze5eKr0guk5lrMFS3iB4=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "2.23.0"
      "sha256-avmh4nUi7qJhgcojH6g9fv/8TlkAvMdPJ5aVahYRU7k=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "2.23.0"
      "sha256-eoNhbm1ib6TI/P/D0b3+3I2ruDhqIxUqAHMe3RK/29w=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "2.23.0"
      "sha256-2mWi/cZgXTjvQFFDAeUq3/AHEzTUvxrV7CthZjokAUQ=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "2.23.0"
      "sha256-KBYJyHBfCefY+mS+y1VVldG4JWWsFtM6U9ADltyhXFU=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "2.23.0"
      "sha256-5O4h0IWSb8GghwH+VCfEfUjoQZRUYUG6Xc21tJO5gWg=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "2.23.0"
      "sha256-aERXnqSiCgrL+U6uZOdoJhZ5GVBTdn31m9ZZF3I0Ny8=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "2.23.0"
      "sha256-QTYS1Cc46D9SB91Jo62rUCbVv8pxRz/3QBbtfaVaDw0=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "2.23.0"
      "sha256-1iA/jEOUbBzou6sWZWmbo+/FgHxUGQXflkrvTeH8IKU=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "2.23.0"
      "sha256-o8QFNN2t+nGOXdln4J6YBXTulAl0+d4Yu6zqyc/kK+c=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "2.23.0"
      "sha256-ToXBnqW8eFXOECwEtKbRK0qzVGXpkDGlgpNPVJf0SjY=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "2.23.0"
      "sha256-iGtlm95Meis7VixXPlhw6Q0sNY2PV0TVKO/a1tVKf78=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "2.23.0"
      "sha256-NJwZUd4YBOKdqTPZZKA64JDndfR2FTZem6rZSDpceXQ=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "2.23.0"
      "sha256-DYvK9rp2IGkJSKLkZh72MHDOJxjpl0O+XrTNXVE/PUo=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "2.23.0"
      "sha256-yrAQe1EWVpCmvVRrxi8hzuj1+BAXisn5s+Y98w+3gCU=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "2.23.0"
      "sha256-BN4v9Xke2Q7YNJaJ2RjKkv6TsXFHwCJkTCpRn/qA5DU=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "2.23.0"
      "sha256-KjCwhlCIf0ssQTYAd9GAD9OtoSu85HROsdkyVPq/ZBI=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "2.23.0"
      "sha256-tptMa1iOrqp03CF63aUaChOPIB16+hoiUzXC2CpL2BQ=";

  types-aiobotocore-iot-roborunner =
    buildTypesAiobotocorePackage "iot-roborunner" "2.12.2"
      "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices =
    buildTypesAiobotocorePackage "iot1click-devices" "2.16.1"
      "sha256-gnQZJMw+Q37B3qu1eYDNxYdEyxNRRZlqAsa4OgZbb40=";

  types-aiobotocore-iot1click-projects =
    buildTypesAiobotocorePackage "iot1click-projects" "2.16.1"
      "sha256-qK5dPunPAbC7xIramYINSda50Zum6yQ4n2BfuOgLC58=";

  types-aiobotocore-iotanalytics =
    buildTypesAiobotocorePackage "iotanalytics" "2.23.0"
      "sha256-+ayqpiMd3r351P9ZYs3NoWWLH/W8vNS0ufLE/l3SKEg=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "2.23.0"
      "sha256-SQQIAqgY7hwzDKQpWCgHJj+OnDsByGDWHe7kFkmqyAo=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "2.23.0"
      "sha256-uU1TuMMEqC4GkPs6BHtp+8oBsxNx0w/TZgt3okRSXc4=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "2.23.0"
      "sha256-rCowW52uz4Kk+RWmFTN6PJ9KEADTCv23/9aXPF9zl68=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.23.0"
      "sha256-4yvaXwObLuJZxbD9GolGwZrpdTTCGkHHTMjr+LjatV4=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "2.23.0"
      "sha256-HFAEg0qdffsC+xqWSvm+iEq5zI25Xje5AG8SuaCz4QM=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "2.23.0"
      "sha256-QV27ZHCuLRY18jySds8iKMKXRfKyIoiYorBV5N23Wsk=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "2.23.0"
      "sha256-B+AaRp7O+UL0WyQNm821you2blSbHRl4ol0NcwWJQsY=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "2.23.0"
      "sha256-z1YUvzYSyRsKLVr6Rss+V5sBDaKkXxcpc7EdmOZq/U8=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "2.23.0"
      "sha256-xVCKkHJKeiLjtMP5hR0QF9KClQYEXWvMxyhm4zIEliA=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "2.23.0"
      "sha256-niY3Q4oD8HPKMVVSz8rom1HBmoHFTUAcyDWVB7Pk9IY=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "2.23.0"
      "sha256-nWtEdrJqnwHcbjHP9o7QpcUzOt9x/psojdiLWKw/q5I=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "2.23.0"
      "sha256-PArVQ5FIiSCcKqkJB34xSlzka4QRTdkDxDE2IQPrIeE=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "2.23.0"
      "sha256-yxZkN62KI3bhg2/nCCYun5bisgbmvNbu5QZ5ukjc0PA=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "2.23.0"
      "sha256-9o3JdFNBHgoEcwBurSC/jQIiUFLVI0bFYSirCuPPCBQ=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "2.23.0"
      "sha256-n4c4DO6xC/fGzU7UDSl23mCtoXuismaYy4YPkd8/3lk=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "2.23.0"
      "sha256-PKUC0aVnfd8NAKNoZ0AntzsmqvYY1p8g6cLDQq/0uDY=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "2.23.0"
      "sha256-aNMDvlITpdovQQlUzAm3S6QaE8JqxkxJ4/bvGFe4imE=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "2.23.0"
      "sha256-vF06lNW64BHMlciqI6pN/cVfWpzdUi+Gty1Jy7+ISqA=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "2.23.0"
      "sha256-5dAX3qX5voPyWfu7z4EKmucWvPr5ODZ8rYKHW34aoo4=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.23.0"
      "sha256-5eAWp+Og0ryCqN3QNaRZlbyU6eQ/llSRIUvMKTVoGMk=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "2.23.0"
      "sha256-tRrWzKPrIbGWm0QDsDuOTR82qiD0epIQ0XNC78fcN8s=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "2.23.0"
      "sha256-a4WEEk6OuwaVsFVZNxpopz1caP52XGHbV2mXGlrfFjU=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.23.0"
      "sha256-iY57BXVOwqtmDBjW2dZbq1MW4dNjbl3/E8TeYI42Srg=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "2.23.0"
      "sha256-5/KqWsefRsyN6w4eHTz1GSWDMMz4PsiP1ijiyXdVwhY=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.23.0"
      "sha256-1NrhcnXiB8ZftlpuXPA1s9N7jCqLaGThM9+RCpUXR4Y=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "2.23.0"
      "sha256-ZFUA0diSvFxcDTnOysAbCczhhfuwklaew7+Wdm/KqOY=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "2.23.0"
      "sha256-X8YY2bzPrXp8V0mzBfSBUt/zEsXUYV3w7UnlUmWqT7E=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "2.23.0"
      "sha256-IBw5McjQYK+guvGsNEHCz+MKIraRaT17na3fMJtHCWU=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "2.23.0"
      "sha256-Sg3wgBy09t7ASUAdTlcVsBO6KkQHrzhjp0TFaK7ZAaY=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "2.23.0"
      "sha256-gKX42gekc3M6ghD3KSj8vuzhj4+TsOCAqcpKfegEq9E=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "2.23.0"
      "sha256-ldSAlbLGF8bskfXkgrQvA7VCmLqLGS5ZN4FXZDvy9gI=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "2.23.0"
      "sha256-wVNUQAQ6EsbJtXsAkxmB9uc9GCfFtCScF3iPxD+h1ts=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "2.23.0"
      "sha256-NMnqq5Zn8I3Ms4Y2T247s3bMYoWtZSrnH0GMgFRXLh4=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "2.23.0"
      "sha256-3llnB61pY+dZ7TIVYN6pI/W6lfYyjmwSUx7ag3KCY74=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.23.0"
      "sha256-mTYiPcwQK/0evuFLkORocXGeXogLVRbQEmQKNfsI1b4=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.23.0"
      "sha256-6e5RMxuLJO0h/NJ15d1ImIpRX8c/cIXyIDhWqLAQna0=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "2.23.0"
      "sha256-07WfJtdRc7FTx2yRFniCItbGc2VAuoykpFL5Cj1rAHc=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "2.23.0"
      "sha256-3K0Ki9f0x4tsUYgGN7Exw1J9idqLftynkoC2+APm9h4=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "2.23.0"
      "sha256-+fysRcfgRqxFVNUtNAur/4a6lkTyC6isEc4jqJdtj3g=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "2.23.0"
      "sha256-e8aIe0Pan9F+EUAXGQVyCEOBCMtVfNYoftN42YG/pNE=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.23.0"
      "sha256-7Ptv7Px7cWHJkr6UqJybjXr2uBeGyrpPLOUEZR2uxcE=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.23.0"
      "sha256-/FG2DYNBNK1AIy+Syoxwtj0sve8tpj4J+ujTBpfkbPM=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "2.23.0"
      "sha256-89wYOO1yYa2EGQyZa55jsnTHd+P6ORme/UCOSflNygY=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "2.23.0"
      "sha256-kjBmkl3DZl8NHenDQGZ1rWcrZ5tD9zq4CYSOucUdM0Q=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "2.23.0"
      "sha256-C0ByVhwNDDYNtM2zeT8gu+nkHcWicvN259AZj5qQTDs=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "2.23.0"
      "sha256-wMJMO3oHHa4g5ilKucSmeK6t38DKxBdoHAnxU09tTrs=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "2.23.0"
      "sha256-U2PSbHoEsF36qoqZfsUco7xGcMjxPgpYZDSFCx9lx6Q=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "2.23.0"
      "sha256-TpnV8tTvOehw/mlTBCfj0Cklmpipoyj4QpKYu1Rf/yo=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "2.23.0"
      "sha256-j+rvG2d4+9X+YVId8APSGqPvdvENQGOUM2xD5hCe1eM=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.23.0"
      "sha256-HLCviyz3zLvNDXokize5D+IwS9rh6Aua9DsAmWzTtOk=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "2.23.0"
      "sha256-hrqFscSVCVVBwCZhEu8M33c4r9zTI8+Xg/5qRGbieqM=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "2.23.0"
      "sha256-PsOaItSVfvVNZi73OxoaFceNGV+jXqzLMZVIYlegXfc=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "2.23.0"
      "sha256-TGP0GNaw1YZhq86tmsLHVUM7MzrK58l7s9ceJcNh1Fc=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "2.23.0"
      "sha256-JTIev0OUp4lwXG1t9EyomzTUV4S16mpTV9EGo6ZjVkc=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "2.23.0"
      "sha256-4aDaFaM0g36Yso4HS4un9+Vx8VjU8dB3ysDCek2QCMg=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "2.23.0"
      "sha256-DdZ6tyKhxueb6ASWXXqnX/sY5QHsxdr470eZaIkJ6VY=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "2.23.0"
      "sha256-8eqKMPzPoOGBhq5ePyI+7Vl94v+4GE0SYEiklZvVZ34=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "2.23.0"
      "sha256-LggFP1WSljM8oiDKCR/nJH5yhjFENXqQJBKcP3cK/as=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "2.23.0"
      "sha256-wvZFPMwRzox9j4DLVRhMmxo1JhpZbTqqnZQcWBRmOqI=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "2.23.0"
      "sha256-6m9kJDW77L3dY7ibHENykl1hIjbwT25sbMpdmVUoKoo=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "2.23.0"
      "sha256-prOOYqT7OQnE3FixnyXuzM2sQy46yZU2uUmdXQVPDos=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "2.23.0"
      "sha256-Z9AVGuba/L7gsh436CCfcM93QMCxvJH+9dAiyvrb0G0=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "2.23.0"
      "sha256-G3nHMMmMjevRS7rbj0nyq5RJZpmEmUgRweduG6AU9bc=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "2.23.0"
      "sha256-GU8ylqHL/wFt1V87X8LbqgKL+oAESrye90Cyr2Kin6o=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.23.0"
      "sha256-midyCWZd+mB4qosvhQaKvrpBTfy2VT+ocFsqYpa9QYU=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "2.23.0"
      "sha256-EOc6NXJ4wfsOGPIQXAS68xKeYpYLtzH0LGiLT8BJQFU=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "2.23.0"
      "sha256-o4l9XB63f6b+ms1PRyIq2xnJA7XwI/A3bVIzSP/6mLQ=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "2.23.0"
      "sha256-/dvSG4887dRD/uPGIcNgf0zFcpzzlXa9uQPG1MiB83A=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "2.23.0"
      "sha256-8cy0q49+mERgZWPo4ghH0QU32h7ar99XzAtFSVLGVb0=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "2.23.0"
      "sha256-jFLewVOOBMmgKZeiRD8JVF8BF+PMkqlMUusBtYh7LFE=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "2.23.0"
      "sha256-j7tYoJa6XSPrRDjNaRH/LQbhXUtGM3r53pkn2gd4yP4=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "2.23.0"
      "sha256-SkUTDAp6GbwjAIl7qZI+9KJU4ciom/aQmJFmNtAzA0A=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "2.23.0"
      "sha256-vVu4RDjgQ4wAgjErX2reX1/gbvb45IK/k+OhQqV7Pec=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "2.23.0"
      "sha256-nVAGZ0L6foSIdPf3wJOlHU4IwYAzjb3g600qJ7rQp4g=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "2.23.0"
      "sha256-g+h3sj1glMrvc4ZpI3TNWXQL07wnRj+XjEnuc37MDdg=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "2.23.0"
      "sha256-dNpjzK7wWHaHURonIBzMEPEH3tiW5UKDsx5DzqKYUVE=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "2.23.0"
      "sha256-xdtjXxT20T95h2rXvPB7YjaK7j7iN9B9ZkiE/E83XFE=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "2.23.0"
      "sha256-ELVpYSnt+prPLO/Xs7wnSRFEgO78YZONfYrjm/RvEJ8=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.23.0"
      "sha256-XlcSk/XIpx179dNqClphcjIkFpXDiMdbHimUATGVnOY=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.23.0"
      "sha256-RgJqHGroVTLnUnUPmNBY0LD6sTXRQ7JlHU26+irRz+U=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "2.23.0"
      "sha256-d+CSEbSHFv22wroOavVVXMNnCRalknFs8d9VeXKGEQM=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "2.23.0"
      "sha256-8a6Z8WfRaxIZ+ASVHhjcnhDmZF45gL9lDW2ozVg1piw=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "2.23.0"
      "sha256-m9mPr2lFBfoQoudmC0Dw1Jk728Z2vrG2XO8IPXArXVo=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "2.23.0"
      "sha256-8NIh4TcknQG7vzcH0/2TwYA/bz0xL9/sDsThmVgejPg=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "2.23.0"
      "sha256-attszmjydteM8ct+SnsdOkFRQaY5KwB8yv+2nKOAmPM=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "2.23.0"
      "sha256-jYICIfUn/9534qY9hUpkT0tIiJ0Cynk03FCAdrP4fTE=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "2.23.0"
      "sha256-z3op5R12xBMyXrs97L3G1P2M663GA8yxYXtbqqsjDtk=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "2.23.0"
      "sha256-6JZHAA07LeDdZ2bhcYeBWNhi03aihHZ5mapUEO7jgGY=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "2.23.0"
      "sha256-fY5E4DZ0a4gCYqsJ6Uq2hy7GieQLoH829q60nSjqNh0=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "2.23.0"
      "sha256-jbuz5lxm71/wxdvYXtLTFd1ro8nhR9LxRSE72egMLSo=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "2.23.0"
      "sha256-d4ZPh1BeUzLTr0awkYTGtYMR8MzC4ivp3tRjgV4r/MU=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "2.23.0"
      "sha256-a2MdLsC0RhmM2nXcQt7UxDloFQNF3ZPKNjwbaG1R8k8=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.23.0"
      "sha256-wgU/hST/e84g9YRsoYNw51C7L727Md+DgClJ3rD7RY4=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.23.0"
      "sha256-HMPT+GcBTSaHVjnWaI3w186Yxr19DlBsIQ4HDB2JlgU=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "2.23.0"
      "sha256-5PKAX3JdogdWvwjxYqO5kZs6xxoOho49LNAAP2XBLKU=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "2.23.0"
      "sha256-vNyV+qV9TOmULrCrqlHLPYeMfh/vrhnUAouPMq5QwXw=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "2.23.0"
      "sha256-9XIIJUTMBPY/z7ohKR4VvfEDrtxxO5dJxRoxxgJyDI8=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.22.0"
      "sha256-yaYvgVKcr3l2eq0dMzmQEZHxgblTLlVF9cZRnObiB7M=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "2.23.0"
      "sha256-OgehX+tfaMf+eG0vOzvEXn4L/oxfYE1m/umwZmbmPfk=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.23.0"
      "sha256-obDHh4yKZMmYNXw3CV8i2h0Py7h8ROCl30xAQ1IF1WQ=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.23.0"
      "sha256-Ar/y7clkyNwPQ/gINuTPwgcribmPlsIU5C5LfPjqpg0=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "2.23.0"
      "sha256-FG9MSLJVgDDspfPsGg7dQ6Jr/sIi1zV1Mnfh5qTpdG8=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "2.23.0"
      "sha256-IarNiXt8yfyO80c7Gz1/wVpWjbcW37UGY/W81KvU1b4=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "2.23.0"
      "sha256-mDJs4hS3dFHVjdlGz/+vAHnd/QbvhyOy1yPLymiOxTQ=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "2.23.0"
      "sha256-IeTdeAvJzdz7FAVwlFD9CYebmiqWpxOqAbqAHFXxe1M=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "2.23.0"
      "sha256-HtMHy6U7hk2vwEUCvuK0XGfItZ0Aoainwcg1Ek4Q2YE=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "2.23.0"
      "sha256-Hda/SIzZO3hQD1dedviFTqvrRH0/o+RTvrLZkSS3xe8=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "2.23.0"
      "sha256-Gg+I+cYVV1AlYR7FIxEUCDMRdo4iu/1S3TAMak+1D+k=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "2.23.0"
      "sha256-1ViY0svyv28PdH0g6avaM4o16+JCRYQF3YZT+Nf3vms=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "2.23.0"
      "sha256-DxR/4S83swPq0k++BMQEFFcFhAJjzJKfhxo9qdKMGh8=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "2.23.0"
      "sha256-wO/HpOWUh+9r4ykKnQ/t8bN7poF51hsoCPwb3po6ebE=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "2.23.0"
      "sha256-WhJSvUSIbm3i53Yf/4q59ljRlJoHcctzTCdfDc5u83s=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "2.23.0"
      "sha256-tGs1nNd+XDP7QPDMB8+0y0mHWwP1xe00309FbHbSBcU=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.23.0"
      "sha256-0498wg6pSZa3S97QeTOvKynPERSHBfd36F1Nn0SA710=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.23.0"
      "sha256-sseUPITt2EFd0L0wtthNpafcwdhRFFjEj6L7T/iRdZ4=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "2.23.0"
      "sha256-USP+WKWDTmk2oCCqEGqqKp7c3NPGR+iUPL1VBfldnxw=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "2.23.0"
      "sha256-7RgP2UmwFjRRskcmvjPAy9pc25KTlmoLvLwUEqkGNTE=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "2.23.0"
      "sha256-jEPcp0akDYVQzBNZtZh1JqshPEqdSxx1YL9ezH9sR5o=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "2.23.0"
      "sha256-/kVoiitpzkbfjsBeYmlkf3xvRojozLqY3jfzq7RgyfI=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "2.23.0"
      "sha256-cQVih6Vpy22upUToMVjsXLLc4bFASXNHEzz4Vwid/as=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "2.23.0"
      "sha256-ts2ejlnkzpkGwaWt3QhWEoABwdmUu3UzyGw2iFFU/DI=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "2.23.0"
      "sha256-4voFvDqGwVnSHPwEBhdYbJriCXhYc5bjEb1Dt/tUhBY=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "2.23.0"
      "sha256-nZqfsDd+FSwVazwOQDg1OuXri/UHDJeVEleAwhW+mLU=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "2.23.0"
      "sha256-WeqPbc1/JX5o0GMm2K4MDxeJ14iAMHpNMZb+Fvtx85Q=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "2.23.0"
      "sha256-iurrXo2FojV0piKlkfZgkqYPnKQecgfNfX/noGdrwiM=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "2.23.0"
      "sha256-FfTnAh7COqJQwMvt0dfdA44RgN0lkGJIYt/MLT+iURg=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "2.23.0"
      "sha256-LPvYxAUu+3Nb72GtE+7m6ZTj/Q9zF78f1GRzd5tMimU=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.23.0"
      "sha256-eKTvzqnvIjE5N5nCbY71+YRMuzDyibMjQFKdflF8Ds4=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "2.23.0"
      "sha256-eoKpKyc+dCyj/0doroIiaEvACwxONqLi5rFJsVYbggw=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.23.0"
      "sha256-e5XuBJDujnOdAD+TyNA1/ufF3b2Yg1HpsRyclzNvJFo=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "2.23.0"
      "sha256-/WcgRGILViJQRFd4O04ErPa47N5N5uDuK2VfE+eYk6Y=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "2.23.0"
      "sha256-3VyAq8+SoQe6fp2741PARpKxNPsfYP76dqOs8bQqchs=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "2.23.0"
      "sha256-tfXh+rOCirgL0F7anaJtOP/A9Tb4UNvN6+gZOje+OQg=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "2.23.0"
      "sha256-ElHUksB/dajAOHvmXUvOJoARSkSLdaU61bV5sFR2/7c=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "2.23.0"
      "sha256-754Vak1Ud42c/DloQSk2ky5AEkD1ozR0Ig6k2GECfLI=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "2.23.0"
      "sha256-wV6eJHIfKGVqiC76gMJx04Y+Xlt4UhqHwIr4fDNp+1E=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "2.23.0"
      "sha256-nVweIZosLcuA6daV2msyqIx1iLIvXvrkuIePZYfTUx4=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "2.23.0"
      "sha256-0svy+dhV4LGqOXFFIxWA9/7mjVR9i7pophUv1ELcu0g=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "2.23.0"
      "sha256-cNa4IOJHymoBV4XzVfQszarTj8jS9A7V+5c87QpiLck=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "2.23.0"
      "sha256-Ro3h5i23rnQeuq9MzwH5K9Isry0uclKq+iiGmR7I69w=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "2.23.0"
      "sha256-9YDwaCd23mRVRBwzsvPe7WZbf8sy83gvQyl6VaK2QMU=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "2.23.0"
      "sha256-orhmhTeaVT6lg8im67/oRJZcgsQhXpjBOiigG0h4lks=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "2.23.0"
      "sha256-anuFEqf5VU8hj5b6xfW+01Or0nLO/K7paonUABslbbk=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.23.0"
      "sha256-Pvr/CcNykCsX8szqKwrRKSrmgDG3KCOuVaJdOqRH2+M=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "2.23.0"
      "sha256-2cuGBxe3Wk1cKB5ELla7Dkjsn6j7J+ATAUH9CBxw2KU=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "2.23.0"
      "sha256-8Rn7TKofuN3CzZxUr/nwi+qRaQX46gAKfDzOOwyI3dw=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "2.23.0"
      "sha256-E0tCR8/iy3dff/SI4ux6h4LVNllxQOfOYaZEdDbQWbk=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "2.23.0"
      "sha256-rVAvoj63J5IU4gi5dMUYZfkFdAE/8rUCvVilRQOJVrc=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "2.23.0"
      "sha256-IUsFVjY/c9zsbsv8u5c80KePlVQxR27HqFHosvdLfZs=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "2.23.0"
      "sha256-NW6qRjs8cCOEAQMSygKe69Yud3Lmc+ufcFVzu18fVME=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.23.0"
      "sha256-F9XwPCav4mP9PvfBRPsXZ8q0twtCOFClJEY7SNTEpAM=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.22.0"
      "sha256-nlg8QppdMa4MMLUQZXcxnypzv5II9PqEtuVc09UmjKU=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "2.23.0"
      "sha256-rTa9nSKnDZJlnBwGC7Fqe749jHt+bpzgmgA9+ANb2Qo=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "2.23.0"
      "sha256-fgp5u2AJyyBwt/lH64+6XoB01AX7pE1D2Y7CVDZKoSU=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "2.23.0"
      "sha256-+6YzS8LEYKszReCnCbUvheeIdYskj6T5fJxtOgKJ7RE=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "2.23.0"
      "sha256-FwFYS7jmuJy+cpf1YgXw0mtC1+AkHOmqF3nAQzzbspw=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "2.23.0"
      "sha256-hhxGycHkBaxU7nhtqO5R73WDVTDNskvv60jSs6nCCds=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "2.23.0"
      "sha256-y30gDJhJMxZEVK//DWDL6FgOWkxjcHsudcUUqUGnGdA=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "2.23.0"
      "sha256-ZbxeAetl5XYzPiFruv7DY/tdTrRYcacfR++ERWT2RIA=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "2.23.0"
      "sha256-lreL3DNc3g5FL/1aa24XZcnYEGePlse50Xw9u8Q8/Bg=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "2.23.0"
      "sha256-TcLIzazSqKMBr6XIvxce6eCH5vinpN0UQGvyvz0Kkc4=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "2.23.0"
      "sha256-Iam+EFxGA0iXoAaXHN50n/2t7kxvug404jRw0fNcEgk=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "2.23.0"
      "sha256-7eqXeYvcKulw3F0aB3nZbOt5i8PbBaB2GyjseO4pg10=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "2.23.0"
      "sha256-kUAiQTsktvxtQpHQOHt/CzTucBCpiQj1bGZxoq+gvvc=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "2.23.0"
      "sha256-n8s1hUwQ3itEI3CTMRWKlFi3HsYicf1Ajy3WU1FmLOM=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "2.23.0"
      "sha256-rYEE6fF1jWC1DoWfkqN2/O9zx9Hg7hZHsDw0vJmXAm4=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "2.23.0"
      "sha256-NrQhjEnvp3FH+knYwgvIa/Nfvkpyf8fB61bcy0NNYak=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "2.23.0"
      "sha256-SCzhRCKwJM0vTMKK3M2BiPaPUOmNhHn4MO+V+RYFMCQ=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "2.23.0"
      "sha256-4gD1De2rBm+6M5jMHygcbMFHjyEg2p7fTfBJSQtKTv0=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "2.23.0"
      "sha256-IAHA5n+y4P2amfYEiXLBA9nZ69a6ppzFeGmRUX4haJA=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "2.23.0"
      "sha256-9/ePgw4LXF2PvhUqcVEZEPTMMb9MtLIlHKhop1VrvGY=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "2.23.0"
      "sha256-4jzX1tsaK93c6xnxKkzCDP3Tb8L3Wsd2IRE1GdVyvh8=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "2.23.0"
      "sha256-pXhIaGPsEPLaHr2YWo7ZvIHyC6JkcsRzzFVf5w4HYbQ=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "2.23.0"
      "sha256-rGIvidbnqnLhar+J5M0oXCvHEn6d/7VHOSjIDHr30J0=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "2.23.0"
      "sha256-mpJuwCu/lF0w8oUWZeAzRbvePfCN1cvy+GKgpvntlpM=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "2.23.0"
      "sha256-VgKs9flRd7/a7L5CznleSf4wl/V4zKtEkBAYWjPYzfc=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "2.23.0"
      "sha256-KtFlxkEmgal61Le39xmRpBPz32m8alO3nmgQGgw/lsU=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "2.23.0"
      "sha256-F4Z1uXVBkA0pDUlUq+pRVFrFQIXt8HESBCf9k6hya5s=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "2.23.0"
      "sha256-Ty3tgpd+1D73MVVxgUr/G7bdn+IOZAQClp9kRLVodvw=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "2.23.0"
      "sha256-E+eTNnbBKbdHruu5V8Ps+Z+dKsDlnz+QmltHjH+t9J8=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "2.23.0"
      "sha256-fB02Ov1jR6qUOzVsfQgxY8WOj18ZuzsZxA76KhH5Ksk=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "2.23.0"
      "sha256-O3uRJxJa7LHq4QrpX5ajuZJYjZhb7/avNJ6PCMsEUjw=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "2.23.0"
      "sha256-o1MF2butL7dubJtfqi57NtgSMz51gwcOH90qX/9en1Q=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "2.23.0"
      "sha256-I+u+pyCnE5R9KY5DjMNUgrV9f456WB3MTaDB85/NJ+M=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "2.23.0"
      "sha256-ZHPaA1jnHuQk/eri+L9LYF4oKKhBj/TajWGbZNo68cU=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "2.23.0"
      "sha256-orS//o/5lIlWHPjSdTdtuPG9vNJzeggzMGpi+XB1jLo=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "2.23.0"
      "sha256-f+aCkdJwpkWg3bQa39aIDGPDTXKry5BS+/nm7J0YBUs=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "2.23.0"
      "sha256-OTv9KmKcMP15WK7UDFg+1yF7qmVTtUKi8vjdzgzejgQ=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "2.23.0"
      "sha256-F5Vnub2S/3knfqXw5VIwbiKElQHcto1KyrRC7u9qiJ0=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "2.23.0"
      "sha256-XrwviZsITloHSwTVGeQXeMN7DKLt5/zTJGyO6/vW09A=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "2.23.0"
      "sha256-NYH52YWk3iyQ9IHWmiTv6peuq5zfpMze2k30dong+N4=";
}
