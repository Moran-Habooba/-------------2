var flagCBC = false;
var counterChangeBackgroundColor = 0;
var tagsToChange = new Array("P", "DIV", "SPAN", "TD", "H1", "H2", "H3", "H4", "H5", "H6", "PRE", "FONT", "B", "STRONG", "A", "OPTION", "SELECT", "INPUT", "LABEL", "LI", "TH", "TEXTAREA", "U", "BLOCKQUOTE", "LEGEND", "BUTTON", "FIELDSET", "CAPTION", "TABLE", "HEADER", "FOOTER", "NAV", "CANVAS", "TIME", "ARTICLE", "BODY", "SECTION", "ASIDE", "NOBR", "I", "MAIN");

function loadChangeBackgroundColor(backgroundColor, fontColor) {
    $(document).ready(function () { activeChangeBackgroundColor(backgroundColor, fontColor) });
}

function activeChangeBackgroundColor(backgroundColor, fontColor) {
    changeBackgroundColor("", backgroundColor, fontColor);
    treeMenuChangeBackgroundColor(backgroundColor, fontColor);
}

function treeMenuChangeBackgroundColor(backgroundColor, fontColor) {
    if (counterChangeBackgroundColor >= 2000) return;

    counterChangeBackgroundColor++;
    if ($(".x-panel").length > 0)
        changeBackgroundColor($(".x-panel")[0], backgroundColor, fontColor);
    else
        setTimeout(function () { treeMenuChangeBackgroundColor(backgroundColor, fontColor) }, 1);
}

function changeBackgroundColor(rootElement, backgroundColor, fontColor) {
    var elmentsToCahnge;

    try {
        for (var i = 0; i < tagsToChange.length; i++) {
            if (rootElement == "")
                elmentsToCahnge = document.getElementsByTagName(tagsToChange[i]);
            else
                elmentsToCahnge = rootElement.getElementsByTagName(tagsToChange[i]);

            for (var j = 0; j < elmentsToCahnge.length; j++) {
                var currentElement = $(elmentsToCahnge[j]);

                if (accGetAttributeValue(currentElement.attr("CBC")) == "true") continue;

                accResetCssAttribute(currentElement, "CBC-color", "color");
                accResetCssAttribute(currentElement, "CBC-border", "borderColor");
                accResetCssAttribute(currentElement, "CBC-background", "backgroundColor");                               
            }
        }

        for (var i = 0; i < tagsToChange.length; i++) {
            if (rootElement == "")
                elmentsToCahnge = document.getElementsByTagName(tagsToChange[i]);
            else
                elmentsToCahnge = rootElement.getElementsByTagName(tagsToChange[i]);

            for (var j = 0; j < elmentsToCahnge.length; j++) {
                var currentElement = $(elmentsToCahnge[j]);

                if (accGetAttributeValue(currentElement.attr("CBC")) == "true") continue;
                if (currentElement.hasClass("oversurff")) continue;
                
                currentElement.attr("CBC", "true");
                currentElement.style("color", fontColor, "important");
                currentElement.style("border-color", fontColor, "important");
                currentElement.style("background-color", backgroundColor, "important");                
            }
        }
    }
    catch (ex) { }

    if (!flagCBC) {
        flagCBC = true;
        setTimeout(function () { changeBackgroundColor(rootElement, backgroundColor, fontColor); }, 500);
        setTimeout(function () { changeBackgroundColor(rootElement, backgroundColor, fontColor); }, 1500);
    }
}