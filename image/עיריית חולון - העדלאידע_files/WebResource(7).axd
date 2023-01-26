var quickSearchConfig;

$(document).ready(quickSearchLoad);

function quickSearchLoad() {    
    quickSearchConfig = { delay: 0, minCharacters: 2, resultsAnimation: 200, URL: _spPageContextInfo.webAbsoluteUrl + "/_layouts/serversearch.aspx" };
    quickSearch("searchArea");
    quickSearch("searchArea2");
    quickSearch("searchArea3");
}

function quickSearch(envClass) {
    if ($("." + envClass).length <= 0) return;

    var inFocus = false;
    var quickSearchTimer = null;
    var searchBox = $("." + envClass + " input");
    var quickSearchContainer = $("<div class=\"quickSearchContainer\"></div>");
    var quickSearchContainerInner = $("<div class=\"quickSearchContainerInner\"></div>");
    var quickSearchResults = $("<ul aria-label=\"" + accSearchLabel + "\" class=\"quickSearchResults\" id=\"quickSearchResults" + envClass + "\"></ul>");

    quickSearchResults.blur(function () { inBlurTab() }).focus(function () { inFocusTab() });
    searchBox.attr("aria-label", accTextBoxSearchLabel).attr("aria-haspopup", "true").attr("accesskey", "S").attr("autocomplete", "off").attr("aria-autocomplete", "inline").attr("role", "combobox").keyup(function () { keyUp() }).blur(function () { inBlurTab() }).focus(function () { initSearch() });
    quickSearchContainerInner.append(quickSearchResults);
    quickSearchContainer.append(quickSearchContainerInner);
    searchBox.after(quickSearchContainer);

    $(document).resize(resizeWidth);

    function search(queryText) {
        $.ajax({
            type: "GET",
            dataType: "json",
            url: quickSearchConfig.URL,
            success: function (data) { processResult(data) },
            error: function (xhr, ajaxOptions, thrownError) { console.log("status: " + xhr.status + "\n\nthrownError: " + thrownError + "\n\n" + xhr.responseText) },            
            headers: { "accept": "application/json;odata=verbose;charset=utf-8", "content-type": "application/json;odata=verbose;charset=utf-8", "X-RequestDigest": $("#__REQUESTDIGEST").val() },
            data: { QueryText: escapeSQLchars(queryText), RowLimit: rowLimit, CurrentWeb: currentWeb, UniqueListID: uniqueListID, UniqueWebName: uniqueWebName, RecursiveWebName: recursiveWebName, SearchMode: searchMode, SearchPage: accSearchPage, RemovePath: removePath }
        });

        function processResult(data) {
            quickSearchResults.html("");

            for (var i = 0; i < data.length; i++) {
                var url = data[i++].Path;
                var title = data[i++].Title;
                var fileExt = data[i].FileExtension;

                if (isAllowSearch(url))
                    quickSearchResults.append($("<li></li>").append($("<a target=\"" + getTarget(fileExt) + "\" href=\"" + url + "\">" + getFileIcon(fileExt) + title + "</a>").blur(function () { inBlurTab() }).focus(function () { inFocusTab() })));
            }

            resizeWidth();
            if (quickSearchContainer.css("display") == "none") quickSearchContainer.attr("aria-hidden", "false").fadeIn(quickSearchConfig.resultsAnimation);
        }
    }

    function isAllowSearch(url) {
        var urli = url.toLowerCase();
        var notAllow = ["/forms/"];

        for (var i = 0; i < notAllow.length; i++)
            if (urli.indexOf(notAllow[i]) != -1) return false;

        return true;
    }

    function initSearch() {
        var query = searchBox.val();

        searchBox.data("query", query);

        if (query.length >= quickSearchConfig.minCharacters)
            search(query);
        else
            quickSearchResults.html("");
    }

    function getFileIcon(fileExt) {
        if (fileExt == "aspx" || fileExt == "") return "";

        var fileURL = fileExt + ".gif";

        if (fileExt == "html") fileURL = "htm.gif";
        if (fileExt == "pdf") fileURL = "pdf.png";
        //return "<img width=\"16\" height=\"16\" title=\"" + fileExt + "\" alt=\"" + fileExt + "\" src=\"/_layouts/images/ic" + fileURL + "\"/>";
        return "<img width=\"16\" height=\"16\" alt=\"\" src=\"/_layouts/images/ic" + fileURL + "\"/>";
    }

    function inFocusTab() { inFocus = true; }
    function escapeSQLchars(str) { return str.replace(/'/g, "''"); }
    function getTarget(fileExt) { return fileExt == "aspx" ? "_self" : "_blank"; }
    function keyUp() { if (searchBox.data("query") != searchBox.val()) initSearch(); }
    function resizeWidth() { quickSearchResults.css("width", searchBox.css("width")); }
    function inBlurTab() { inFocus = false; setTimeout(function () { hideResultsDiv() }, 200); }
    function hideResultsDiv() { if (!inFocus) quickSearchContainer.attr("aria-hidden", "true").fadeOut(quickSearchConfig.resultsAnimation, function () { quickSearchResults.html("") }); }
}