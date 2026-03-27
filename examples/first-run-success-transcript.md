# First-run success transcript

```bash
$ node ./scripts/setup-runtime.mjs guided-setup --write-service
{
  "ok": true,
  "mode": "guided-setup",
  "runtimeRoot": "/home/user/oc/shopify-runtime",
  "shopifyAppValues": {
    "appUrl": "https://shop-node.ts.net/shopify-manager",
    "redirectUrl": "https://shop-node.ts.net/shopify-manager/shopify/callback"
  },
  "next": {
    "step1_startLocalServer": "cd '/home/user/oc/shopify-runtime' && node ./shopify-connector.mjs run-server",
    "step2_verifyLocalHealth": "curl http://127.0.0.1:8787/healthz",
    "step3_exposeHttps": "tailscale serve --https=443 /shopify-manager http://127.0.0.1:8787",
    "step4_generateInstallUrl": "cd '/home/user/oc/shopify-runtime' && node ./shopify-connector.mjs auth-url",
    "step5_verifyStoreRead": "cd '/home/user/oc/shopify-runtime' && node ./shopify-connector.mjs shop-info"
  }
}

$ cd ~/oc/shopify-runtime && node ./shopify-connector.mjs run-server
{
  "ok": true,
  "host": "127.0.0.1",
  "port": 8787,
  "callbackUrl": "https://shop-node.ts.net/shopify-manager/shopify/callback",
  "webhookBaseUrl": "https://shop-node.ts.net/shopify-manager/shopify/webhooks",
  "healthUrl": "http://127.0.0.1:8787/healthz"
}

$ curl http://127.0.0.1:8787/healthz
ok

$ node ./shopify-connector.mjs shop-info
{
  "shop": {
    "name": "Dev Store",
    "myshopifyDomain": "dev-store.myshopify.com",
    "primaryDomain": {
      "url": "https://dev-store.myshopify.com"
    }
  }
}
```
