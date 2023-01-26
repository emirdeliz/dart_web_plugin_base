# dart_web_plugin_base

[![Test](https://github.com/emirdeliz/dart_web_plugin_base/actions/workflows/test.yml/badge.svg)](https://github.com/emirdeliz/dart_web_plugin_base/actions/workflows/test.yml)
[![Lint](https://github.com/emirdeliz/dart_web_plugin_base/actions/workflows/lint.yml/badge.svg)](https://github.com/emirdeliz/dart_web_plugin_base/actions/workflows/lint.yml)

This plugin makes your development easy when you call functions between dart and js.

### How does it works?

The plugin uses a simple approach by setting a simple Js on the assets.

1- Sent data from dart to js.

```javascript
/**
 * This method is used to send data from dart side to Js.
 * @param - args.methodTarget(required): The method will be called on the js side.
 * @param - args.arguments(optional): The generic object with the data to get on the js side.
 * @param - args.file(optional): The file like txt or pdf to get on the js side.
 */
window.jsInvokeMethod = async (args) => {
  let result;
  const methodTarget = args.methodTarget;

  switch (methodTarget) {
    case 'getClient': {
    // result = <getClient implementation>
      break;
    }
    case 'getProduct': {
      // result = <getProduct implementation>
      break;
    }
  }
  return result;
};
```

2- Sent data from js to dart.

```javascript
/**
 * This method is used to send data from js side to dart.
 * @param - args.methodTarget(required): The method will be called on the dart side.
 * @param - args.arguments(optional): The generic object with the data to get on the dart side.
 * @param - args.file(optional): The file like txt or pdf to get on the dart side.
 */
window.jsSendMessageToDart({
  methodTarget: 'uploadContract',
  arguments: { id: 13211 },
  file: File([], 'contract.pdf', { type: 'application/pdf' }),
});
```

### Requirements

You need to add a js file on assets and then add this js on index.html as well. See the example for more details.
