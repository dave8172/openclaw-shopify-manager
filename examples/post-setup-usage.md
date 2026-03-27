# Post-setup usage examples

Use these after OAuth has completed and `SHOPIFY_ACCESS_TOKEN` is present in `.env`.

## Show store info

```bash
cd ~/oc/shopify-runtime
node ./shopify-connector.mjs shop-info
```

## List products

```bash
cd ~/oc/shopify-runtime
node ./shopify-connector.mjs list-products --limit 10
```

## Get product by ID

```bash
cd ~/oc/shopify-runtime
node ./shopify-connector.mjs get-product --id gid://shopify/Product/1234567890
```

## Find product by title

```bash
cd ~/oc/shopify-runtime
node ./shopify-connector.mjs find-products --query "Winter Jacket" --limit 5
```

## Get first product match by title

```bash
cd ~/oc/shopify-runtime
node ./shopify-connector.mjs get-product --title "Winter Jacket"
```

## Natural-language usage ideas for OpenClaw

- "Show store info"
- "List products"
- "Find products matching Winter Jacket"
- "Get the product with id gid://shopify/Product/1234567890"
- "Get the Winter Jacket product"
