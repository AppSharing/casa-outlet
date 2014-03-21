var escapeAttributeValue = function(str){
  return str.replace(/'/g, "&#39;").replace(/"/g, "&quot;");
}