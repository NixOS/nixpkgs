{
  lib,
  aiobotocore,
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

      src = fetchPypi { inherit pname version hash; };

      build-system = [ setuptools ];

      dependencies = [
        aiobotocore
        botocore
      ] ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

      # Project has no tests
      doCheck = false;

      pythonImportsCheck = [ "types_aiobotocore_${toUnderscore serviceName}" ];

      meta = with lib; {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = with licenses; [ mit ];
        maintainers = with maintainers; [ mbalatsko ];
      };
    };
in
rec {
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "2.11.2"
      "sha256-hUS1ZTj9CbC74Aiinmeh2BEQ2KymcqxuYVSeD12s5xg";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "2.11.2"
      "sha256-XtL7R0UrgI/9rSxfNYbA0Lez+DiVyB7R+rhn49Nxerc=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "2.11.2"
      "sha256-vpE1GuvKFPsBf3rTk5V6B4ujFGaHE3wk9yN3j0sM0bo=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "2.11.2"
      "sha256-g9a2ad5hZonlKWGnLQchfT5CAgwqsvseeQBQemCSCQw=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.12.3"
      "sha256-eSIy045Ai6VGJTJbCq7sOEskFByShCv1D8S+XyCdP8g=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "2.12.3"
      "sha256-Q9LX7O74paxJtFgBXpmMHmE5Oymr+KsKc7/a4LkxXsc=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "2.12.3"
      "sha256-/2Ic2KPevRUyQyv2w95ESlGLa1z+j6c7wqO7sJhkglk=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "2.12.3"
      "sha256-Z/yUxzo0dmcZbguurdnkplc1xF7Ro7t0Fpp4frqo8fw=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "2.12.3"
      "sha256-Nziq7FXFXAGfzV36uLVoXJP3N/gA3ydhR1zOL2DAi50=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "2.12.3"
      "sha256-2k0txnK7EV4REsOEynvy1+twaP5rJVI6yIBO59LSKww=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.12.3"
      "sha256-0GVRVAWl4NrqJScy69zhNt/sFq03gquN2CbEPoja1ug=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "2.12.3"
      "sha256-+CpKEb30BCdrRAE/3xO3wIBxMXLTyCOJxu4YScDDk6k=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "2.12.3"
      "sha256-/90wLlLiPLTKxnAqgqhTbtc1hmSalzwD8yHh7/shrFs=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "2.12.3"
      "sha256-KXNCQswudY3MGCBd37kGXuG6TJz3jzD7Y3LsWLvWPYw=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "2.12.3"
      "sha256-1pfpKQ0tmQU3Rm8DGPfDsALecd9XUeeQq/H8Tnp9v4A=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "2.12.3"
      "sha256-c7pC0InqhtHuDKlEln9lt3tQL6w7Af9vxXuIZnhrdqY=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "2.12.3"
      "sha256-lJJXK+Wy6PvAQaCrKDe2GdHEjkuIY+mFmQt62xj21y4=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "2.12.3"
      "sha256-n1EMzB6uPQtYz4sSx6uvhk3ONjX9olg+5OkJoX6QUUo=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "2.12.3"
      "sha256-m9STzjg6PfbKi4mxM28Nh5eDVPPaoSjwLhy6bJ5z8vg=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "2.12.3"
      "sha256-fOZzzkp4q11/pM7tFVsUCuxcAbp09icWOq7Ys89u8Q0=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "2.12.3"
      "sha256-Ovib8qtm+ZCIJ/cQwVB5ksmYpeO8xDoIvkgvnRhL2jY=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "2.12.3"
      "sha256-hRsWYed0ZwgfgkXRAuVfsmAuaJqTYogLVXtQkDGskMI=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "2.12.3"
      "sha256-cpXkWYtPnkVDGbkhgy8s5DgvEHYLRe5Huygkfk/W998=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "2.12.3"
      "sha256-Dem6NGryjCUzQBMCXCNFvop51KhdmIopDUjI2OofEGA=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "2.12.3"
      "sha256-qAMj0+7ywqR/89lUUyRcaqPdVgbARYLdjqMFKOuohZI=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "2.12.3"
      "sha256-D1RbyLJdOrMm1dGq6FiRPYEZ1pbMTA14tJEyukqtFXs=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "2.12.3"
      "sha256-Oqr3fp5uXPeleOlSFGzqeS7yUcqI+WJlPsLsYTBWfp4=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "2.12.3"
      "sha256-f32qZpqQ27sujqeA5V7opwQ2LBLuLgcKEvYxgn53Z/A=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "2.12.3"
      "sha256-gZItvHv6bKmUJo7N68E43nNipGuVPru1FpirryM613A=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "2.12.3"
      "sha256-n7TwvQPRPpjucEdl8oqhRCyuoUobC94eoaxo3fUcX0k=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "2.12.3"
      "sha256-y5tONAuzm2ReIX2ZbXkgCdm1mdOwELVTiI/E88y3RRM=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.12.3"
      "sha256-XMNbgsaMB1xCMffocyb8Qm/vVgwUFJ3HR7vjS4WNJjg=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "2.12.3"
      "sha256-+agBXcUaXKm0gmrLk5S5CUaivA7UOxQegBFXRwNIRoI=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "2.12.3"
      "sha256-188KzcjDcJF5uoBKsFNBSxrFThz8HzuF20dUA4+2aqY=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "2.12.3"
      "sha256-Q17Y1YmrT8DdP/iqeXXFg+Nixx6602jVp7EvwglZXHA=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "2.12.3"
      "sha256-R1qcbs1TFd/hqXBbE1byIBHfhX71LXITICQtT1y2E0w=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "2.12.3"
      "sha256-zpwmqCaymuhlXNQFmOXRwedgyJXqnbKQkzaJVmL+YcI=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "2.12.3"
      "sha256-qoOzWvS2oU27h0G3rDJrD3A7uDTT1nE3r91Jurs1VL8=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "2.12.3"
      "sha256-c4lXCVVtzb1nYHpHCkC6GhaKAGh59f10HOF4pt6jDZQ=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.12.3"
      "sha256-UiUNm5obofAynGBDUU9dDTnALCgquEeD0CWikJoffcg=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "2.12.3"
      "sha256-PRgs4jqH+H77oq8TJnp8BvxFe+VeGAt2HJqGAswsJ48=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "2.12.3"
      "sha256-jhelKCrofsCsoEiQCgkgbmyxPDEzRmrflzsOYEG5VBg=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "2.12.3"
      "sha256-ycz16wpxuooSUJNo2EF578mQ/vuN19wORbRO4KIYAlw=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "2.12.3"
      "sha256-chPRscE8/t0zweeG2oI9Ffe9MhUfro3r67WPQMRrVVI=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "2.12.3"
      "sha256-MsppSKc4o0kkEn+YS8fjmRHMMHCk/vp7MzwWSeMbfO8=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "2.12.3"
      "sha256-QtvI10XobuCCTdbJZk1JV8rbUnaKp1NhTQA4pOrl/8A=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "2.12.3"
      "sha256-mrLk190wtLVLBY9oLKCBcGgNRRsOF4SAxMnyDvHif2U=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "2.12.3"
      "sha256-vjNBwP+SPBXBO9c7W+zOm800kNDfQYHs58ERS82/Hvk=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "2.12.3"
      "sha256-xD0zbOk1Vjzr3DslNSQqFBIIN4NliV3rVlAmUcgfp7E=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "2.12.3"
      "sha256-PXuzI5csFVH9FbW7U0p71U9N3Avmjy0SK4ULdnqyWv4=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "2.12.3"
      "sha256-FBC4K4XZglWNdXvaf5vgk0KwlaO4HgQ+CsTxX8RpJSY=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "2.12.3"
      "sha256-0bIEY8/+KkoRXyaxV3XlsvNbhZGgi5Yfkaoe2G8Hx7U=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "2.12.3"
      "sha256-sQJloZGuAt3FDiVu0rXB4fs6LQ8Ypwanbhk905JlAWE=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "2.12.3"
      "sha256-kir3GveVZbvSEjnna0xKETIA/qKLgCZUxQ95WCw25vY=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "2.12.3"
      "sha256-o+CM6IzDuQJz/Hcmzs4Z//21ujWzILBVN+TpfW0BnAc=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "2.12.3"
      "sha256-s0smSONUSY6hwm81yQXTa0hOe+0FfYHWJ+a2V8vWtnQ=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "2.12.3"
      "sha256-ueY0F1OWpMsFOOSzsE+P4aJ4r0R5UhoefuNyBL5kFSQ=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "2.12.3"
      "sha256-FdTkOmj1ISBgBTcdf0z5QK/LxvsTobvKMqAd4hFK9bc=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "2.12.3"
      "sha256-J4kvblSIcjSsdtTIcxFEO5Dhno8Q8yrD1t/CYr4wmaQ=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "2.12.3"
      "sha256-ipolOmnH/0M8Y+GY8qoOPhoDfs1nqMqoMotT2n/BSB8=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "2.12.3"
      "sha256-aEIj+XsEq35mzKliuUICkIoJV3Mx+l7kd+pFP+mX+Us=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "2.12.3"
      "sha256-UxR7jMxmKeqo2dazqRsnGCHmeycL2uwmuOxzN2Ug06I=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "2.12.3"
      "sha256-Dn8upHxWZMl5QRye+v47vlgi/SqhQi8PUOcVX8no7zQ=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "2.12.3"
      "sha256-s1hhUmQ09fkP7DRGAoajbBrIr8AWioJBXO6vC/kbk9s=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "2.12.3"
      "sha256-pS8TgS/thI4GJY7TqdSLFjnWltjZraE8QDV02GlL0Zc=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.12.3"
      "sha256-jciY4abtX0IMbxCGPrOshFQE8jNyqDS67UqUgt0UYe4=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "2.12.3"
      "sha256-W1/tJKDFRpHB1hsguuAbDCHe+lzh0UAIWlqYVS83MyI=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "2.12.3"
      "sha256-1r65KMMX+A6Ww3+MgG9kIXH48zI9yxt/FbNXq7ATACs=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "2.12.3"
      "sha256-Njd/E0EgRqq69EhYhbrmcu71GFvoqG9vI61i4RXIInQ=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "2.12.3"
      "sha256-eFjfo4grkBO9FGUySGAOclXUjJ+RzaeI0FG7GqZweNc=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "2.12.3"
      "sha256-wSOf6kdxIA2oe2a06c9MuIxnvmPb1UZoY+TPKKWNgfA=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "2.12.3"
      "sha256-TSZn6O5sSqutb+hcA5tJWplkN8jN7q1uVfQyoK6p+sM=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "2.12.3"
      "sha256-foykefLjYtgroFE14HAKJ0qK/vL7U6LGGP3z8P/ZV9E=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "2.12.3"
      "sha256-HM7wBstqaO6pnvXHGTgiIa1FcdJGImW/2BFl/stRJ/w=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "2.12.3"
      "sha256-Ab7L47TU/w5Mk36MJGb3VfHG1wXyHmePDaP37FnQikM=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "2.12.3"
      "sha256-R+p+mV/+SMFaWczEwECfoReQ9KBswiYj0jGysFPn/LQ=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "2.12.3"
      "sha256-KuyJAoend5pAMEEh1EbqUuhWwoFSI5QyJhL/T4fg3vA=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "2.12.3"
      "sha256-8RDp99dyEgxBQNJbQXMxU6Td6rCKBaOtvk22mGVkMpo=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "2.12.3"
      "sha256-ka9T0Ln54mHiPec74fHYkOBL3RbJJ+hVOSkqh35LBXs=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "2.12.3"
      "sha256-nAUWrVmTO2PbB4aJERZaZ2NBdE/fH5pyj2UYPxn1BJ0=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "2.12.3"
      "sha256-tXkoU2hPbB0IYR0QP9yKSLwRknrIcupeeIjHoZD8id4=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "2.12.3"
      "sha256-DbLeEVfr1xXtwIT9eqBY6+Enk1AFfF4ChzOeSO2jSc8=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "2.12.3"
      "sha256-TpmMtpIVdE2SPr+ZaKHUoNqJQFoglcyF4pBIn0jkW9Q=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "2.12.3"
      "sha256-fKUL2ZJgytMhv4rni6lD92M1uh1vnUfFcjh30Tdfofk=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "2.12.3"
      "sha256-x5t5rK4UQ4ltFqSB2dyG6NXrzoJLPBBF8Ovn8Fka8Mo=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "2.12.3"
      "sha256-eMMWqVDoEmIJV3P4aA15bXsWEJ1cBpcvFf6elzvKBsM=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "2.12.3"
      "sha256-TMD7XAqQivkQJbwBr6B4s629euXQyvxglG+hFhH7C8s=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "2.12.3"
      "sha256-JV8EpsEUOmeGEvSmb2zUboota0wu99TcvBcwkYGFa50=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "2.12.3"
      "sha256-1SRrURvp+hOnYWZsANu8waOJJ4SUBzGPAEFwNFyW4zc=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "2.12.3"
      "sha256-3XTNHMYWlZUK7o7XQYpnsCq3FHBYuXJ6y2iVM+caKcc=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "2.12.3"
      "sha256-kfeH7r2zaNw3gDH7QqKe2x93kEfzeUMY5aBOJFDz3vE=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "2.12.3"
      "sha256-0fsNThA4QJhTC8JlTJviOv+GwrMvVQxoddvRX4+Nrtk=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "2.12.3"
      "sha256-acjirpyoMe2Mq72IuGHb85q/B0UHhQ2wEJO9Cy+OHmQ=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "2.12.3"
      "sha256-Z4V00bBobcChsYr6MPJ+pwCV1VJwHVMeks2URMVGzgk=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "2.12.3"
      "sha256-JG8rHk86RHyCEeLPGHERMZ1f+gBAcS+TI+RSfxVWkdI=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "2.12.3"
      "sha256-t6ybt/wp+YL2qNyI89RzijJT1qPX6cBykQ803F81Q/0=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "2.12.3"
      "sha256-MI9e+SYSjbO8PMRFa8VSyAfoupTb8wzhO+DXCcQgu3Q=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "2.12.3"
      "sha256-qsyiQH75/L2HPM/QrQ5nrf9Bh+7xClIQggCWSA/7xho=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "2.12.3"
      "sha256-ms93yRBMH/9hVVyN5jGZqP6Su4qdP/oKRHyAMlM5Nis=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "2.12.3"
      "sha256-sBsjF7ZIldzEN6LyXy9r9zmeKMEX8QXQE7GKYmXrYPg=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "2.12.3"
      "sha256-0SZQFZf19WRnNA0uTbOoHxfuVZ/Oo4HgttiJcJ+ec3s=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "2.12.3"
      "sha256-nGyIT/TXqUMRWwA5tIDie1ktVwy0tspw3avgJ//kW5k=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "2.12.3"
      "sha256-8OPqG7wMdu92O0BfGb9zI5Wj+NFA25jWZN0dvzQV0Yo=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "2.12.3"
      "sha256-Va2yM0tmcIj4b2wXUzWyhuhv5lhcfCslR0h0C7A5EsY=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "2.12.3"
      "sha256-FshaLIdFjrTh/bxE9X2to7OMqORJUl/THmE4rhIFbFI=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "2.12.3"
      "sha256-GXZ0wSgko3LNMoWFdGAk75Z/ALecaJNJjog9zog+0pY=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "2.12.3"
      "sha256-JumaYfl8+YpgxAnxZF+1IW4Xhw4UuT2wxX979xbGFqc=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "2.12.3"
      "sha256-Ea6AgjHGqrUNP8TF6PFNStVAuRED80agLuzhjdkIUM4=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "2.12.3"
      "sha256-JceWf2TRg+t55trAJhFAp4YVarc56ZiZYdjB7lhP/cc=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.12.3"
      "sha256-hhgI8CplzvzbKVPB43udHODE+td4B4Tdk2vls+JNyn4=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "2.12.3"
      "sha256-DnZqKJCvFFzgjncV6w+Cxi7HTtA7A7t/RGJyQ9icYos=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "2.12.3"
      "sha256-HC3+b8rFuJshIax6g8oLFMSxxHcbYHP3HDvP2u3UX3U=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.12.3"
      "sha256-jXW3LMDaQgXL7QVUJ0OxEUaNfPED5GjXefbWzzf+MGA=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "2.12.3"
      "sha256-L5be76HYM3piIMrbP0QiaLKc6YOdqPMR52fBuNkpLx4=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "2.12.3"
      "sha256-MCM9zyNpUUt4aAO04aMmPzg+r71VqQzeV4eH+ukBZiw=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "2.12.3"
      "sha256-5hCuf3QgmnKhaI8L5BmZfOztgsB9Quy/Zwwu3vutKj0=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "2.12.3"
      "sha256-Qq8koQIHkd4ZsuYfAnW7wpCgRzpGaFyKRCN5WQBIqJY=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "2.12.3"
      "sha256-b5iOWjrnxCT/enOPOixlD4tdav5DMavg32xlqE2u4DY=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "2.12.3"
      "sha256-aIFYYN2GPbDYPjQsbm9D6WPNRAGmFpfkQPhLYwGwZH8=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "2.12.3"
      "sha256-xVn8IRXYklNychp8P8z79yVVwlCYzvhmnhSgq9LJv8Y=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "2.12.3"
      "sha256-8n9aFOaZYqQvwnb1Yt509JhZjNisL+dY3PVqkxbwbQA=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "2.12.3"
      "sha256-8QZLlmUwuveQf1dXbJZGUJC2XiKA4vrdxG6Ee9F+jPA=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "2.12.3"
      "sha256-icXRzSXSn/M50jVun2Evm1QB9m9feFGWazKSvZwCa30=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "2.12.3"
      "sha256-dPw16YNaK5CvMNWxdkK0vNVzXcDY3hocWr9ffg2vtGI=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "2.12.3"
      "sha256-xcFTvd7d+lrXiJ4SlxiznwFfFRHnxmTZk6vwVurICvc=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "2.12.3"
      "sha256-ivJ/ekU1qvjuOXnLNXUUoGp/xc0DtHnqh4QwqUyIwk8=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "2.12.3"
      "sha256-ddMnkPvFyn2HG88pYapA3TWbOgV6DRLbnSWdd5CauyM=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "2.12.3"
      "sha256-RvaEG2bWIOOOdPOk1A/CW+UTtYMuQ3ZyD0tYfLzOhfc=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "2.12.3"
      "sha256-I5vvbmW1BO0ZfKkQEXAhcGb8Q9DMKXDR9AYFcAm6bLM=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "2.12.3"
      "sha256-NGi+3jWxWPMlsKGDjdWzcORI6ElDbtVexeVQh71cego=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "2.12.3"
      "sha256-1vl16o9foO6wmumbOvgF3FA8vEOjpCmkcHaktY8pEYY=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "2.12.3"
      "sha256-FARwguNmU+BDV5XyJSL4dqGESEoKmXPjVoPU6ktzRIg=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "2.12.3"
      "sha256-Xpob7f0ucl+F+X++5GAdQ4B0IgF4YM7oRFFbm77n4LI=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "2.12.3"
      "sha256-aMaPlDZGLvuPDjH5p8bKU0JYRImjheJnpP2oKshtVDY=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "2.12.3"
      "sha256-d9rFpL4iv1k2zJgE8qQymisVDuOJMEL6ZuQkuV78d0U=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "2.12.3"
      "sha256-jmavkKefg/AZMrhU1bhI6Njy78MDNrT+3riIaKIAUlY=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "2.12.3"
      "sha256-zvg/8evrSn14vr9RJXeI4YVOiwva8GwdnCHKkfMygKk=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "2.12.3"
      "sha256-3DHm+EPlUQA3LHs1Pbi+B9ipCGg/sN7F5etOzJoXTMY=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "2.12.3"
      "sha256-0n8ec0H/Nz7Z5Dl7cK/BdxCSIv+wmP/jsS+uL9+ar9Q=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "2.12.3"
      "sha256-POI2RmnRoUfjx74/MC/Nf9bqxsn3jUnkzHwuY5b7Oy4=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "2.12.3"
      "sha256-5sa+9i8KahglRVdJnTqp8zYUHfvGq4GCfcMYhd2qJdU=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "2.12.3"
      "sha256-CQDgDkaJ0hbmsRMxxBXGBOzn2XU5DG4uBFUOl3P4XwY=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.12.3"
      "sha256-NDecqTRmki4/c55vpjW8aCLW9fkKvkDRHAMrf54P9cM=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "2.12.3"
      "sha256-0zxf9IpiVF1nxY+Cfk631+vTtjojo8Ky4M69zfU62MQ=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "2.12.3"
      "sha256-GZnXAGM2WMamZkyHmxb/+uRfUtLmmXCkN1yRgUmO1pE=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "2.12.3"
      "sha256-ValWGfzRPnhA2HVwF/bHfCEv/NCOYoOjVPplRomIXgw=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "2.12.3"
      "sha256-o609SDjx1+dzBTmNSGuoh8H6XLfZLJgaqUJVEmG3gzU=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "2.12.3"
      "sha256-ymj+ugkTQkGEloCtdnFsmwXtLmMnpgxsgINsZjCnPCI=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "2.12.3"
      "sha256-+kC/viBAYxGSP80pStaSD6bIXN5pdwu96NA6lcfIWzM=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "2.12.3"
      "sha256-iCVPf+7LtTfRvrX7vKt2DNkfw1xdTCpzlqvA2w4LsjQ=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "2.12.3"
      "sha256-YJSr/C6V7yASlg2Ifif8lAYsy9zOo9ficn0DWmWIZB8=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "2.12.3"
      "sha256-7LJRrYAcyil9Trw8gCu7lOkrdcSW5yQeZOrQ1bPL+qE=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "2.12.3"
      "sha256-An0qRP6UxBOHwkQ7e/a0ZN9c0drgC8uYz1xXslEwStc=";

  types-aiobotocore-iot-roborunner =
    buildTypesAiobotocorePackage "iot-roborunner" "2.12.2"
      "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices =
    buildTypesAiobotocorePackage "iot1click-devices" "2.12.3"
      "sha256-5PQV2KlzOpRWkeJhsPFwCZ8iZQp+flTH1UUGn3q3/7k=";

  types-aiobotocore-iot1click-projects =
    buildTypesAiobotocorePackage "iot1click-projects" "2.12.3"
      "sha256-FuC8skyo0yoqd+He5cOKlUUnPiGk9I8vUen0uj5Eqcc=";

  types-aiobotocore-iotanalytics =
    buildTypesAiobotocorePackage "iotanalytics" "2.12.3"
      "sha256-EPHXokF9XO/0EAOnOyhp2MUfs7UHozFKYbWqPeDFweQ=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "2.12.3"
      "sha256-iZVZJZFCrwmKpYglS/UT4Qew1GdttI7rwn+XduS2DPc=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "2.12.3"
      "sha256-bxW0Wtqua7ny+kv8bSdyss/MFxLWDMqCxbojBsjtNY4=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "2.12.3"
      "sha256-jOVKCfHNJmfGHnqG/y75qz6hsYUWrD911KCV3amWldc=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.12.3"
      "sha256-gp2YjRDGXRFBrHnzs5m/SsugG7U6hh3NvYG8ym5/2FU=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "2.12.3"
      "sha256-YHZZUZmmmE6T8Z+Vvh4SZEf5xrzzObLKP6EuGY+aIaI=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "2.12.3"
      "sha256-Bx43NAwPTlPqZrV3SN39amD0on7RJvvXC27QJ9kShWY=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "2.12.3"
      "sha256-fXmG7vvCgM24P+WwPgVlh+uVJdzT3r5dgEf5eU2763w=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "2.12.3"
      "sha256-1rdcWFEfM9paoGxm3NhS/A5tDMCgCoMkGeXUG49i238=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "2.12.3"
      "sha256-AEp5cF3vVj5t/M7J4hSuk7KsUIKN9sSpSk2XfH4w8Hk=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "2.12.3"
      "sha256-LfmlJGalNaiZB1UAqG1XwDPNBKxz0hO2S9EiTakmtmA=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "2.12.3"
      "sha256-vxFbBTyf0psVvc0N8kAEJrX/JumRoWD5GKQ2JmkJkPg=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "2.12.3"
      "sha256-78x0QtBZsBztNaAqiUCtosIf+Lm3DCJqVerRBOLiEXs=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "2.12.3"
      "sha256-/yakndOCbZlLhARZ6jd6eG0YLRZjg8Igw4Fc15obqRo=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "2.12.3"
      "sha256-oayTFZfzOURWDfzexxrHxV/JdJDXAmk9LupPWMFZpkc=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "2.12.3"
      "sha256-pA6EEsfS9W1uK7s92CGqZtk3o+GUI92T/lFOqCQotTI=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "2.12.3"
      "sha256-RPSoV974cSYfPL1cFnpZjcMQeSENxThtG44zWUemN9E=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "2.12.3"
      "sha256-A5o/guqeDNvH27DCB5SAJuOmgSMYSrJjru5qn3sOL6k=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "2.12.3"
      "sha256-1gACiFQAo1iCzITBQIcRNId8S2t3L7ga8MiC1oKQX58=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "2.12.3"
      "sha256-jcFBnfzUcCyWt5qOgiCx/2Lbf2QEGW4G7JjTNclGy/k=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.12.3"
      "sha256-DkvRjmHxmyj3TWQK5FxsgpU8vm+I7d7dibkI6rwGg8c=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "2.12.3"
      "sha256-cDko/AYbz8KLxheVLhGhYr9eUOxB6R3JCoNCXyOBL48=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "2.12.3"
      "sha256-f/8FAIf6DFf0ly5qRhG+kFHYzs4whggUsxhphA2bPuM=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.12.3"
      "sha256-dIvQeCqeL+oBy0N+uTcBTbkkNfGfrgKwGYrI8XaLeYQ=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "2.12.3"
      "sha256-nEc26wCazquuuiOVbWWpa7ab4ZQE0TElsWrbIuL2VHE=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.12.3"
      "sha256-MX/moxuQphb6YaO3BeuMhDyvuYG8WEevYizg0yQq4Pw=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "2.12.3"
      "sha256-G3kO0yM3jbw1RdRo5JX7Ju2vzsR+7GXeLjyoPGFIEQg=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "2.12.3"
      "sha256-6JfxOXCsDjP0QqYqXBiPXp3R31mBL6Z4xUwXMFHGgdI=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "2.12.3"
      "sha256-KuXvIcrlvCA7ATv6az1Oeoe0CCysnCUb/B/D9+pd/Q0=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "2.12.3"
      "sha256-4RSFi2CyKz/0Y3d9xIYM6CpOONTLP1X8rJqzJolVdck=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "2.12.3"
      "sha256-EoASjvQ8uJy15SVq5vNek+vMqNgU40/Rj1i1NwWDHuk=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "2.12.3"
      "sha256-JbL9RhcnbNll+68jzuiF6coqdMYeYLYkuPJz85Q4gAg=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "2.12.3"
      "sha256-cTndR1V9msDL+8NIqp6HRvSmP/rhZlwVuZwLKBoitZA=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "2.12.3"
      "sha256-V/PGGRZDXhilxUE5YslkyiJYWulQkEsxQZbaAbPP/cU=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "2.12.3"
      "sha256-zA+rcTsvrOFB1/st0q9vK4L0YZTGVlk0XNl5gxcxSK0=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.12.3"
      "sha256-vGzT4Q90+FeF8tELo3zWp90MqrbNJ95kzovjFbnz9LY=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.12.3"
      "sha256-qI9Pw+lK7JGSKEl+wxZz1CmG7UG1AsDmxkHuYY/sQxQ=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "2.12.3"
      "sha256-hl58xChUqHdkl0KtZjMetrR+am1gHIPZtSfRXSQg6ac=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "2.12.3"
      "sha256-nTBbzRhNWl5B1tGlaQVd0eKbnBvy/8fmDZ4kY9de4cU=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "2.12.3"
      "sha256-mmmR4vLdjfNys1uXGMbvF84/CrI6GKNH/tRkneHI9PQ=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "2.12.3"
      "sha256-rSoOIJywU+Vzh73LQac0ugfiu2r25SHdsgIjHmmHZnw=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.12.3"
      "sha256-hrVID1/a/McspXe+Tl6VPTApYJpjERa1Hb4QmTtWpBM=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.12.3"
      "sha256-KYxkVAaRxZxCHz4FBFNaZUrSLbtumaU1Qh3w467nPjo=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "2.12.3"
      "sha256-1f6YJ6a9OqmJ1szPMao5l3zAs97grpDr4SvldDNohV4=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "2.12.3"
      "sha256-0b6bNQvxR+OJd/hyM47qAM5/B0ALYEkWJqO5OosKOtw=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "2.12.3"
      "sha256-sd30ATrunzj5kqZDJLGd7sGdxtpBcR0Kl1qG2QhqeFk=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "2.12.3"
      "sha256-8uZkHItyZfvSv8rr2PKYLHVDHxeL/f/Z8mcHYXBsiXw=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "2.12.3"
      "sha256-n3hInygsT+Zkl4TTjZ7gtkvT7npEvvl6HoNpRW0kI2M=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "2.12.3"
      "sha256-GkzlSr5zRispSfeIe2pmOMlLhxoBctn9EM1VXTnMSkg=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "2.12.3"
      "sha256-61Sgh1moietvRwtc2SrJhWZ5y1ZobI+CiIlL+zkbbgE=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.12.3"
      "sha256-//+fB39zKqT9n+KIa9fMHoj4Oq5S5bq1vwsnEorPS2g=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "2.12.3"
      "sha256-DoIwvqLsCmcUR4UaEvTShKf6sYs3iQDyWkuDxz//cB8=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "2.12.3"
      "sha256-ESAo1QuHtL7T5fZMP15bwxtjDdymDOmz0MX/mcDd82s=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "2.12.3"
      "sha256-ZF+D7dzjmQNntkyM271BePIbCchA3o1naO/sChfYrGo=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "2.12.3"
      "sha256-OiwnSNch2kbYfNbKNCPSrhg+9yAe4sktibGEQ3MPyXI=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "2.12.3"
      "sha256-tmBmDVpO4hTT8xMuFpeAl1Gx+m+MacalYwdxKO8k8o4=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "2.12.3"
      "sha256-siRePAYIWMPCaivNTOCjhfafut6sQzFYqpiGO4rO+v8=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "2.12.3"
      "sha256-S5o0T8mUQ1ppq4vPdNeBr5FjcNpRtFPRQG4C/MZye2U=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "2.12.3"
      "sha256-q4AFkM7keYfHWmnFOM5r1xHpVEnDjWsAmyATcfC7264=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "2.12.3"
      "sha256-PLyaXf2/hrmo4YGS6KY8aXyhEv5ewGPWVsGoHS0Ui2g=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "2.12.3"
      "sha256-3ZFHete+MHeUGomdkD54eCqwDfshP+5Vtf+jTOkRZww=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "2.12.3"
      "sha256-PB1wrc6y3enPpB+Wk3ciL7F1dgU8bqRxE5FarSaV/80=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "2.12.3"
      "sha256-rKVoKaY63jArGx0R5Y9Xnp7OoztedmbshmB9d338LzM=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "2.12.3"
      "sha256-bUWSyqyUMzvSQSMkqEPJYjhLoAXG1hUcIqHY5bpAito=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "2.12.3"
      "sha256-I/NeUqOmAXeiF1Sej2LJkMOgKw1Lz4c7YrNJMf+Q4Ac=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.12.3"
      "sha256-0mOX1FRHqlY4FggS/ieTRzc6I4dwoNT6syl0lUiSnFs=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "2.12.3"
      "sha256-CiobxWUFRuAI5qKFDO1zRQj5Xtp+RzMVjwGm2ZSBijY=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "2.12.3"
      "sha256-SZ+e7oEbPvRY8J6jLePeoG7osJv7zPtn9SV5z4cU4gU=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "2.12.3"
      "sha256-vO0Tjigj2x/HsA5gPsPU1peloI7GMvHXHe8dtsxSGTg=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.12.3"
      "sha256-s1ddYopINo+Q6T9QuD1sQ0P1UYgGxmYaSjxW6eCxK+Y=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "2.12.3"
      "sha256-tEvBlyvVNNDLRHe8UPzdjnq1hA5QqPDUdtuS2zj6zu0=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "2.12.3"
      "sha256-59BieemJgQXv3YyitmffaeD7oxlQAKT8xX/E/VxG0JY=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "2.12.3"
      "sha256-ayUivauZR/s6ivrJA5DFviFgH/rq/f3KYGimULyoizY=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "2.12.3"
      "sha256-bzIzK9sKecGyKvEVWvgwis8Lm9HRP/y49MSnQQb1XGk=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "2.12.3"
      "sha256-2Ze/cG5ixrzYm0jZ4hByh7Wz3nAzH3/jyopgFyTUjdg=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "2.12.3"
      "sha256-F14ejhHjbv2BmfNng0hmI34+aA8pVCf4L+Cvn2Kx6Jc=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.12.3"
      "sha256-8WpARJKsOatdQXzmFt30FFri8b1h3bBeyydbZ73kPMc=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "2.12.3"
      "sha256-qJlO69CxqQnDekL7KRoQEkDd3w5rCxwJ0Z6RRGZxVgU=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "2.12.3"
      "sha256-TA4kRoEoYZ6awy9TL550xT0sjVg2FEdfOQLrBEurCTo=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "2.12.3"
      "sha256-uDCRtJuEKNh1HuHCq+YjucLj4VAoHTiqVaOvVnTDJr8=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "2.12.3"
      "sha256-KMftaU+mCA1yUnZ1/N1C4N353Lulnmue1Y95GGmIAPg=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.12.3"
      "sha256-0YVnEY6G5Huj3pnvouc6LaIPHb0uJdRkwF2/EPknFd0=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.12.3"
      "sha256-o+tbhUjox4tueImh0cWLqe8Z0xDaDmA1BGMUmFDoEkA=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "2.12.3"
      "sha256-uZ/hxE2GOIPcbtlyG82sBA+uT4RxAORvck4WjghJ+kg=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "2.12.3"
      "sha256-kxa5cYYzTSpPmLHV+1ZKjBAC4S9ITmT0p/NI34rQwSs=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "2.12.3"
      "sha256-Xf3CuvPjTQODNeSmI+meP7aHj9a26lPGWQ7nWfc/FjE=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "2.12.3"
      "sha256-nzkVKxoLpkEBthjyO4d2m8QsEVz2pYsjfBC0sGsTkrY=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "2.12.3"
      "sha256-7H0ew8JQNCUkbNiqCH4jCoO883j5y1hbxXqwwJARuTs=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "2.12.3"
      "sha256-awVZZf6o0VRTqOl1myJggGdCmwoC5XBTlYSeupceWr0=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "2.12.3"
      "sha256-j+q16/K4NSdsLmt+vXF3SEy2Kde+/6BxEZ05zOOPI2w=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "2.12.3"
      "sha256-YY3hOmgc5ZU1rrN5cbHoIS54eby1AM2vYPz//fGH7Mw=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "2.12.3"
      "sha256-D8k7Ui77IvVkpODg7p8SQLO7We3/EYhZaHODsJskJgc=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "2.12.3"
      "sha256-sOLfoF0t58cvdvB8LModo1fs8cPovn9gkg0d0opDj1c=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "2.12.3"
      "sha256-YMB/QCn6zawXBB2Fw4he6CIdZFMz4s91IZIbx1W5RwU=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "2.12.3"
      "sha256-7MCEh3ICp+3qD6Uijk4/wpEzaP56khP7lG/1RJ26IJg=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.12.3"
      "sha256-qCnMdlF9VwoTpXxgMObmOa61xzj8NHQoxJriMEbWUPs=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.12.3"
      "sha256-eWOhKQR0tTlqLKCmy3zWvRsg5Y0zRKxtQPM8DGEbvuE=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "2.12.3"
      "sha256-kKpp8rQ/co4tJhi1xpuEaIpICy+8sM4grp6bu9HsGMw=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "2.12.3"
      "sha256-lwU91zv+IhHXBoGtioox9iB7lqGxXwf+s3A43qDZFRw=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "2.12.3"
      "sha256-n3bM48N4nqgXA5XQ+2lHgqyfADGP8pt8MDcpd3Afdbc=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.12.3"
      "sha256-EvxCTzjfaxz3sj7S39I1MvOUo5n4vnc4h0X4bWevSwE=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "2.12.3"
      "sha256-/0MAjPO7xXsuePNUGpqpSOORe6GsH8IpbZUj4F9+Jp0=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.12.3"
      "sha256-2LbMUzIge0Jf+iGDI06ne7QP3EMoiVY3m1KOniiRnsw=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.12.3"
      "sha256-Ooj8lzd48n+tcICQgAJT9z//7r+obDdv4jvTNTAhzCw=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "2.12.3"
      "sha256-aZGpaXSomaU0+oFEEuN1C/1zjA4UAz4vn/Nu2JJThrA=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "2.12.3"
      "sha256-bauCdG3Qf4Uiyw0szQL7SBm7QmYSmcDAOW2nW23xlQ0=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "2.12.3"
      "sha256-zitp/IE5zJL0qKF5TM3nQdUA1qgSeCSGcK/WS3niRUA=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "2.12.3"
      "sha256-scJBwjmxy+UmivIBKl5ncB0/JQSeSwSh3wA30EWH/+o=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "2.12.3"
      "sha256-KmEecWh2Z0O6eoRjEClzDC/Vp3qYwrPtdIW6ty2/jM4=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "2.12.3"
      "sha256-H0GqZM72tVXcvs6ciE9wcqOAQfECU84iKn2VdGaNhIg=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "2.12.3"
      "sha256-3eJxMH1JvdJ1n9XnC/6+q7rT5ipaUE/J5G++O1MGf40=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "2.12.3"
      "sha256-+KyAzCuPDV9QTx5COJZjGRpiciYdSHDaaulH++s8Olk=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "2.12.3"
      "sha256-AZ3tTUTTQsxIDn7hmq5DkepvOGRA/OBGC7O0Y9ZCqb4=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "2.12.3"
      "sha256-mAKlLfWNTYpYA7QJl6VLHv9Kl4xNXKsRFZJbCEpLjdI=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "2.12.3"
      "sha256-Tc2AoAADC9+ElCBKqATsRqAlq12gNcJKr7evJpbZejg=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "2.12.3"
      "sha256-U02sdfU+FPpcKf7KP4WEIhwbew7CHnXUhE497fYmEXk=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.12.3"
      "sha256-Ydf20+setw1400AydFrUHUWQdvNE4g2x23Q9Vn+FG+0=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.12.3"
      "sha256-trj8NpEEUJTB0WEzX1XyVQtofWH/j52oNb9CKL/lpSQ=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "2.12.3"
      "sha256-xd23IpWelx5jtNTBWtCJZEIG4m/o0dpHlXi82goX8m8=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "2.12.3"
      "sha256-oEyb1NE+3wDStkvUX0gtJ6Bzp/oHIUw1gyQVdFv0PXw=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "2.12.3"
      "sha256-lnWLEXErO3LO4teDnVnkGRawfEXdh2EgkDL9RVp941Q=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "2.12.3"
      "sha256-FsnXHspKP62zQiB0zhX28V3yeLAMNqMW6JHTVtGVjsk=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "2.12.3"
      "sha256-mAWpWgYqjnoIHJzw3nNNQA5m5bQd+mkU1536hDb2K+w=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "2.12.3"
      "sha256-sm1A/O/k62QDcmrhv5mpHZ3YqixRWcPnV2VEL9AfkFs=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "2.12.3"
      "sha256-wZVYaDPSU5d0xTeCJQcPi0hiLRt4pvrbMozalM3fIUA=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "2.12.3"
      "sha256-IMk/fTHusesqUz0k9KC0TIDcCiShh+DSdQowOBBpeJg=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "2.12.3"
      "sha256-UcY0A+OAG3Dfi6HfH2leuknKraIHceX6pWcPsXElzX8=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "2.12.3"
      "sha256-SSD5mCt392ZE0SmypwASM1HeuqnNFbnBjsI/8Uwy+Y0=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "2.12.3"
      "sha256-iFrAYHvNIpgH+M6HeuogIZJiRiyzLhuOboEF3ipCCug=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "2.12.3"
      "sha256-DTUta+jol6bEAisciUDPaiubNdc7CE1DC2njjPVCuEw=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.12.3"
      "sha256-+DV7vYutJqk3pcA8gaXVQW2foTKD07elUUFyMi13QT8=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "2.12.3"
      "sha256-SFZJnRXUDM5qlvMf6nTso38RmBXKbN3xqOdXFwoCOEc=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.12.3"
      "sha256-PnVM2KeIEodV1RVmiXv6Zh80NfnzxV3ih3RpNYJlnzw=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "2.12.3"
      "sha256-Lg2PR/AB5yqsRwUWZfIf7vP7Ig2G8APEZRzCXUm0H48=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "2.12.3"
      "sha256-Iv6JOyRcAfkaNdq/m2ot/e8CTZREWIE7V+tEsZNZ3HY=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "2.12.3"
      "sha256-/jd4KgxRbV9IzTGDm0BkcQ5UIaRpDyLBUFZXLsaYzA4=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "2.12.3"
      "sha256-PgrfYlgmvM7QtF0E1z4xi8gGK+ixZykxvdEMpTz3SZw=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "2.12.3"
      "sha256-jXpQJ1Uw2nOVZpkXtUf1mCrS9YykBJcvVMCp5Jz9558=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "2.12.3"
      "sha256-PiRnAEU/+r/VT3SiboaUpU9FRyOs/3Wj5wCJDyzKZNU=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "2.12.3"
      "sha256-17iQmuTvmeMDkz3fRxYlE/JcCy/XTuCNmlG5EGGY1S8=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "2.12.3"
      "sha256-Yk0GEeSSl3Bhx9w/uRrrl9oNjpdw4ekye1Ia38fpvXE=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "2.12.3"
      "sha256-iZzzocPVbiWn6ZaHOEu42hcOLJyjgIRWCJpeSiQE3I4=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "2.12.3"
      "sha256-q9e+7s3//qaswRo1wwIIhtEz7qszUKuHXXG3n4z8piE=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "2.12.3"
      "sha256-sqFr4/WFedUrgVK9PAVffaA4lhEK510679P/RoTv4xw=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "2.12.3"
      "sha256-vCRTtFjQfCe38y/wZaxjIfHRLzkqAakDf/sNXtU2TOY=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "2.12.3"
      "sha256-9EXbCcvcrXmKktoZXp+LdKXQOi6V9VKHrFVR++XGhOI=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.12.3"
      "sha256-VenvRShJhVaZHkM0MN+iEZHGeOeqbAYneRW0lB4+fww=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "2.12.3"
      "sha256-fK38DE6aGY03HmtIBBhyxX4pjA3XOiKKZJ2iMJeZDP8=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "2.12.3"
      "sha256-oYoq9cMFB7qKjUccWa4iunjlwizUA/pevKcQiHS68wY=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "2.12.3"
      "sha256-JR16UIvxYyWR+T7Ar9ft8rwxZrqwyzKy5pVJMi6kzbA=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "2.12.3"
      "sha256-tuzWmBEyMr9k4isVkg5ybz7NBwKl5udmHHdokUVILog=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "2.12.3"
      "sha256-jy6cpicBp423tHyp6ALwPro0CwPddDfQHdo9KBOOtLo=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "2.12.3"
      "sha256-fDVnFlLYm+8lfSVfFAGu5sjqrVIjmC0WCPpPbIhyf9w=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.12.3"
      "sha256-RF91H0JiSTScbqvFbKHkid/Wp7+Qr/qLc6UT9bltEdY=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.12.3"
      "sha256-nT82/oiMPjWyVbwWLhLjRoQoEMZERe2ET2ti2OnefQw=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "2.12.3"
      "sha256-ama8FOWJb2czu+++Ps1nSKCnwZxMk9SP0OGHzX02x7Y=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "2.12.3"
      "sha256-elqHFPOYXK8xx1XC5yDkcPJPyY2x0/FKt3Kor+gPk9s=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "2.12.3"
      "sha256-HfqnblwWhnFpVfFe6a4OLPQXuSZB+SzKRS5u39viIjE=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "2.12.3"
      "sha256-m4tcWZXlixyURA7V1bJvThC1VydPmalqIdz7JrqsEl0=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "2.12.3"
      "sha256-Zl8oXCdd7lPPNpIF27EPUfPcTVnwfjCBKfS1/t0ta60=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "2.12.3"
      "sha256-TYFO1JBWesLY+oNg+k4IdR5OOtrddgUgDn7ONGARRKU=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "2.12.3"
      "sha256-IzUQDV1C6TGKT+UXA2c9C6HVBlrg3qHynH/+7klH/6E=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "2.12.3"
      "sha256-xaXFwmc+VBX005jom+oYI0fjqebI2BN7Mj14+dVXGQE=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "2.12.3"
      "sha256-ZC4pgxkd0NM+jxOrdiZCoMv39N5dp6yvCfcbkuWxKkE=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "2.12.3"
      "sha256-chLpz3GeLrw6SbnmqeZntzFZb8YseYXswmlU1icccMs=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "2.12.3"
      "sha256-P7D0/lG3YJbQi12viIdd/Ykl3PCC1u/EAE0oqZv0zAk=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "2.12.3"
      "sha256-sYm/6MQNZfRL88M6JPhgZUrPV0r2kWfiNT9nPQB1Uwo=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "2.12.3"
      "sha256-bdVAioN/pPSA3Ma7PPFhAVL4L1E7clZJzPct0k7ABp8=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "2.12.3"
      "sha256-aQyVJ9UWizJuKDkko6+xHNIONLq3hI+rQfHsPaW6JVU=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "2.12.3"
      "sha256-pJg8YolBrgYx0FwW3J60x2S9H4XymC0XlBBilb1YIEY=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "2.12.3"
      "sha256-NMG419sd7+MjfBEGjaDYcr7kHCE3R3wAY5rFLzfIg18=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "2.12.3"
      "sha256-HFcaf+erCthcjXILJYmkH1YDM6xGR1DVi9xd61/UmUc=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "2.12.3"
      "sha256-91qq9ziYFML/0rdn3SP8glsG9mW1LUjvqPlNDt4Fbwo=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "2.12.3"
      "sha256-WQFJaP++IIr0eWa810stZzMM0gW5Cxh3CPVTfuFzhYg=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "2.12.3"
      "sha256-TOXo/JhCp8+dD0umfIuokpF/lmUgFfsMLOoLtkiZNpg=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "2.12.3"
      "sha256-teNvXZu8T74wuYy13s9UvT2sBc/Q8pT27Mj0lP1uDa0=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "2.12.3"
      "sha256-y3efi+c+4NOXvdnc+y/PMD2CuFuLDGU9HwFUgkNV8HU=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "2.12.3"
      "sha256-RdPWi2yNUdoDh3vrQGJx7BoF8tfYO2h9e0juwuNZTPY=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "2.12.3"
      "sha256-svX7Mr99aXUcYxtuFDAuEYvBF16IJqWbRNjubgxtRww=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "2.12.3"
      "sha256-AY9NzJprshQe5UPAERG+DquylhKLtec05KMjM+CfJx4=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "2.12.3"
      "sha256-bH15twDf36YZuWTGhIdl2XsV9CYxrTRstI8+9otJA0A=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "2.12.3"
      "sha256-BA/JY5cusubF2NYIFOotM14O6YHEmcP9PX59ksnj8e0=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "2.12.3"
      "sha256-YYH5fIP+7yWLwm/UlAfdQWACsXXuyqGPNVWx1ZTsKq8=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "2.12.3"
      "sha256-3vNi+7zjFmOsphhkiCe3sL3xGc6vJn+QxXfnJiGzeRE=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "2.12.3"
      "sha256-v/NoOoMS6KwZotYZsCIqwQ3EkUusaK5YuCnQz3eBhz8=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "2.12.3"
      "sha256-DI5GBYssyNe5yDUD9EF4+waE1d/SD6iDyNK93Hhbl38=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "2.12.3"
      "sha256-g+EwfgHlhvFWHlQsjZriiPHFF+VzLlMAo9LtX+AImlc=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "2.12.3"
      "sha256-EHqZb51vIHt4ox9Zd9G/Hl6KGWd7vIipjYn+ru3zwTw=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "2.12.3"
      "sha256-/lVbhKOMtyTSZEEgzKH2DySZM1+Jv3LM4TJAauTWyLc=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.12.3"
      "sha256-agu/CSxY1gjcVTU42I2DR9Rxrk0c9GANXJe16Nx4U1I=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "2.12.3"
      "sha256-XYf1bnCmYZI51uvJY9IG+imcUyqNO1AUc3gWF/jMhkA=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "2.12.3"
      "sha256-qMBxt5KkYqfDqWAFJVdch2edQCIl+lP5lyjAGkMriN8=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "2.12.3"
      "sha256-KLg4Q2VvinCIBhqD33CnpXqSjaex8JlN0vh1BIq1bpE=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "2.12.3"
      "sha256-y+iQviR02Kuy0czNmKJOefkI9AVBgGGXGm8DQPxVoXM=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "2.12.3"
      "sha256-l89VAkb3pdSU559nWIaipZOYsRG1DGz1wEDKOyehe0Q=";
}
