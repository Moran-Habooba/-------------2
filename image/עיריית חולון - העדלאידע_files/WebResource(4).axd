var flagCFS = false;
var counterChangeFontSize = 0;
var tagsToChange = new Array("P", "DIV", "SPAN", "TD", "H1", "H2", "H3", "H4", "H5", "H6", "PRE", "FONT", "B", "STRONG", "A", "OPTION", "SELECT", "INPUT", "LABEL", "LI", "TH", "TEXTAREA", "U", "BLOCKQUOTE", "LEGEND", "BUTTON", "FIELDSET", "CAPTION", "TABLE", "HEADER", "FOOTER", "NAV", "CANVAS", "TIME", "ARTICLE", "BODY", "SECTION", "ASIDE", "NOBR", "I", "MAIN");

function loadChangeFontSize(fontSizeAmount) {
    $(document).ready(function () { activeChangeFontSize(fontSizeAmount) });
}

function activeChangeFontSize(fontSizeAmount) {
    changeFontSize("", fontSizeAmount);
    treeMenuChangeFontSize(fontSizeAmount);
}

function treeMenuChangeFontSize(fontSizeAmount) {
    if (counterChangeFontSize >= 2000) return;

    counterChangeFontSize++;
    if ($(".x-panel").length > 0)
        changeFontSize($(".x-panel")[0], fontSizeAmount);
    else
        setTimeout(function () { treeMenuChangeFontSize(fontSizeAmount) }, 1);
}

function changeFontSize(rootElement, fontSizeAmount) {
    var elmentsToCahnge;

    try {
        for (var i = 0; i < tagsToChange.length; i++) {
            if (rootElement == "")
                elmentsToCahnge = document.getElementsByTagName(tagsToChange[i]);
            else
                elmentsToCahnge = rootElement.getElementsByTagName(tagsToChange[i]);

            for (var j = 0; j < elmentsToCahnge.length; j++) {
                var currentElement = $(elmentsToCahnge[j]);
                if (currentElement.attr("changeFontSize") == "false") continue;

                var currentFontSize = currentElement.css("font-size");
                var fontSizeType = getFontSizeType(currentFontSize);

                if (fontSizeType.indexOf("%") > -1) continue;
                if (fontSizeType.toLowerCase() == "em") continue;
                if (tagsToChange[i] == "FONT") currentFontSize = getFonsizeFromSizeElement(currentElement.attr("size"));                

                currentElement.attr("CFS-CALC", (parseInt(currentFontSize) + parseInt(fontSizeAmount)) + fontSizeType);
                accResetCssAttribute(currentElement, "CFS-font", "fontSize");

                if (currentElement.attr("changeLineHeight") == "false") continue;                
                accResetCssAttribute(currentElement, "CFS-line", "lineHeight");
            }
        }

        for (var i = 0; i < tagsToChange.length; i++) {
            if (rootElement == "")
                elmentsToCahnge = document.getElementsByTagName(tagsToChange[i]);
            else
                elmentsToCahnge = rootElement.getElementsByTagName(tagsToChange[i]);

            for (var j = 0; j < elmentsToCahnge.length; j++) {
                var currentElement = $(elmentsToCahnge[j]);

                if (currentElement.attr("CFS-CALC") == "") continue;  
                if (accGetAttributeValue(currentElement.attr("CFS")) == "true") continue;
                
                currentElement.attr("CFS", "true");
                currentElement.style("font-size", currentElement.attr("CFS-CALC"), "important");

                if (currentElement.attr("changeLineHeight") == "false") continue;
                currentElement.style("line-height", "normal", "important");
            }
        }

        if (rootElement == "")
            elmentsToCahnge = $("*");
        else
            elmentsToCahnge = $(rootElement);

        rootElement.find("a[href^='mailto']").each(function () { accResetCssAttribute(currentElement, "CFSWP-word", "wordBreak"); });
        rootElement.find("a[href^='mailto']").attr("CFSWP", "true").css("word-break", "break-all");
    }
    catch (ex) { }

    if (!flagCFS) {
        flagCFS = true;
        setTimeout(function () { changeFontSize(rootElement, fontSizeAmount); }, 500);
        setTimeout(function () { changeFontSize(rootElement, fontSizeAmount); }, 1500);
    }
}

function getFonsizeFromSizeElement(size) {
    size = parseInt(size);
    if (size > 7) size = 7;

    switch (size) {
        case 7: return 48;
        case 6: return 32;
        case 5: return 24;
        case 4: return 19;
        case 3: return 16;
        case 2: return 13;
        case 1: return 10;
        default: return 16;
    }
}

function getFontSizeType(fontSize) {
    if (fontSize.length - 2 <= 0) return "px";
    return fontSize.substr(fontSize.length - 2, 2);
}
