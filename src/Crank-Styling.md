# Crank.js Style Handling: Objects vs Strings

## What's Going On?

### Style Object vs Style String
```javascript
// ❌ Didn't work - Style Object
style: {
  backgroundColor: selectedColor,
  width: "200px"
}

// ✅ Works - Style String  
style: `background-color: ${selectedColor}; width: 200px;`
```

The issue is that **Crank.js doesn't properly convert JavaScript style objects to CSS**, but it **does** pass through string styles directly to the DOM.

## Is This a Hack or Valid Code?

**It's actually MORE valid than you might think!**

### In Raw DOM (Vanilla JS):
```javascript
// Style String (what we used)
element.style.cssText = "background-color: red; width: 200px;";

// Style Object (what frameworks usually convert)
element.style.backgroundColor = "red";
element.style.width = "200px";
```

### Framework Comparison:

| Framework | Style Object Support | Style String Support |
|-----------|---------------------|---------------------|
| **React** | ✅ Converts automatically | ✅ Also works |
| **Vue** | ✅ Converts automatically | ✅ Also works |
| **Crank** | ❌ Broken/incomplete | ✅ Works perfectly |

## About createElement

You're absolutely right to question this! 

### createElement is NOT just Crank
```javascript
// React
React.createElement("div", {style: {color: "red"}}, "Hello")

// Vue (render functions)
h("div", {style: {color: "red"}}, "Hello")

// Crank
createElement("div", {style: {color: "red"}}, "Hello")
```

**`createElement` is a common pattern across frameworks!** It's the underlying function that JSX compiles to:

```jsx
// This JSX:
<div style={{color: "red"}}>Hello</div>

// Compiles to:
createElement("div", {style: {color: "red"}}, "Hello")
```

## What This Reveals About Crank

This suggests that **Crank.js has incomplete style object handling**. Here's what different frameworks do:

### React (Complete)
```javascript
// React properly converts:
{backgroundColor: "red"} → "background-color: red"
{fontSize: "16px"} → "font-size: 16px"
```

### Crank (Incomplete)
```javascript
// Crank doesn't convert properly:
{backgroundColor: "red"} → ❌ Doesn't work
"background-color: red" → ✅ Works fine
```

## Best Practice?

For **Crank specifically**, using string styles is currently the **best practice** because:

1. **It works reliably**
2. **It's closer to native CSS**
3. **It's more explicit**
4. **It avoids Crank's style object bugs**

### Production Code:
```javascript
// For Crank - use this:
style: `
  background-color: ${selectedColor};
  padding: 20px;
  border-radius: 8px;
  transition: all 0.3s ease;
```

// For React/Vue - use this:
```
style: {
  backgroundColor: selectedColor,
  padding: "20px",
  borderRadius: "8px",
  transition: "all 0.3s ease"
}
```

style
The style prop can be an object of CSS declarations. However, unlike React, CSS property names match the case of their CSS equivalents, and we do not add units to numbers. Additionally, Crank allows the style prop to be a CSS string as well.

```
  <div style="color: red"><span style={{"font-size": "16px"}}>Hello</span></div>
  ```

Refer to the guide on the style prop for more information.


Style prop syntax and type

Crank.js requires CSS property names to match their CSS equivalents in casing. Unlike React, it doesn't automatically convert camelCase to kebab-case. For instance, use font-size instead of fontSize.
The style prop can accept either an object of CSS declarations or a CSS string.
When using an object, numerical values for CSS properties are not automatically assigned units. You'll need to specify units like "px", "em", or "%" explicitly, as shown in the example in. 

 Using the style prop with an object
Ensure the object literal syntax is correct.
Example of using an object for styling:
```html
<div style={{"font-size": "16px", "color": "blue"}}>Hello</div>
``` 

 Using the style prop with a string
You can directly provide a CSS string to the style prop:
```html
<div style="color: red; font-size: 16px;">Hello</div>
 ```

 cssText property for inline styles

The cssText property can be used to set or retrieve the entire inline style declaration as a string.
Example of using cssText:

```javascript
const myDiv = document.getElementById("myDiv");
myDiv.style.cssText = "color: green; border: 1px solid black;";
```
Setting the cssText property will overwrite existing inline styles, so use it with caution. 

Potential causes of inline style issues

Incorrect style property name: Typographical errors in property names will prevent styles from being applied.
Style properties being overridden by other CSS: External stylesheets, or styles defined in

 \<style\> tags within the HTML, may have higher specificity and override inline styles, which have the highest specificity by default. The !important flag can be used to explicitly override other styles.

JavaScript execution order: Ensure that your JavaScript code that modifies styles runs after the DOM element has been loaded.
Incorrect element ID or selector: Verify that your JavaScript is targeting the correct HTML element.

Problems with the getComputedStyle function: This function returns a read-only object representing the element's styles, including those from stylesheets. You cannot directly modify an element's style using this object. Use element.style to set styles directly. 

Additional considerations
Performance: Using inline styles extensively can potentially lead to performance issues, especially with many dynamically styled elements.

Maintainability: Mixing CSS and JavaScript can sometimes make it harder to manage and update styles across a large application. Consider alternatives like CSS modules or styled-components for improved organization.

Crank.js documentation: For detailed information and specific examples, refer to the official Crank.js documentation, especially the sections on Elements and Renderers and the style prop.

By carefully reviewing the style prop syntax, ensuring correct usage of CSS property names, and addressing potential overriding or execution order issues, you can resolve most problems related to inline styling in Crank.js.


see: Crank.js style object not working Crank.js inline styles broken Crank.js style prop cssText