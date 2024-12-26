const playwright = require('playwright');
const fs = require('fs');
playwright.chromium.launch()
    .then((browser) => {
        console.log('OK');
        fs.writeFileSync(process.env.out, '');
        process.exit(0);
    });
