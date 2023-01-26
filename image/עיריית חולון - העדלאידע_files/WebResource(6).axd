var valB = 0, val = 0;
var accFirstFocus = null;
var accWinWidth = $(window).width();
var accAccState = false, accFlickState = false;
var doneArrB = new Array(), doneArr = new Array(), accHtmlDialog = new Array();
var accAutoSaveFormCookieID = hashCode("form" + document.location.href.toLowerCase().split("?")[0]);
var accAutoSaveDelimiterFields = "~~";
var accAutoSaveDelimiterValues = "$$";
var accLangID = "HE";
var accInitSignaturePadActive = false;

accSetLangID();
$(document).ready(accPageLoad);
document.onkeyup = accDoFastLogin;

function accPageLoad() {       
    setTimeout(function () { accSetAcc(); }, 1);
    setTimeout(function () { accSetSearchValue(); }, 1);
    setTimeout(function () { accSetSearchTitle(); }, 1);

    if (accIsAdmin()) {
        accCalcHeightActive();
        $(window).resize(accCalcHeightActive);
        $("body").css("position", "fixed");
    }

    try { extraPageLoad(); } catch (err) { }
    
    setTimeout(function () { accInitReWriteTable(); }, 1);
    setTimeout(function () { accFixForm(); }, 1);
    setTimeout(function () { addSkipAreas(); }, 1);
    setTimeout(function () { accFixAccessibility(); }, 1);
    setTimeout(function () { accFixAccessibility(); }, 500);
    setTimeout(function () { accPageLoadSharePointLinks(); }, 1);
    setTimeout(function () { accConvertToMobileTelLink(); }, 1);
}

function printSMSError() {   
    console.log($(".smsError").html());
}

function accSetNewWinIndecation() {
    if (accIsAdmin()) return;
    var newWinLabel = "נפתח בחלון חדש";
    var align = "right";

    if (accLangID == "EN") newWinLabel = "Opens in a new window";
    else if (accLangID == "AR") newWinLabel = "يفتح في نافذة جديدة";
    else if (accLangID == "FR") newWinLabel = "Ouvre dans une nouvelle fenêtre";
    else if (accLangID == "RU") newWinLabel = "Открывается в новом окне";

    if (accLangID == "EN" || accLangID == "FR" || accLangID == "RU") align = "left";

    $("#siteOnly a[target='_blank']").each(function () {
        if ($(this).find("span.displayNoneIndentNewWin").length > 0) return;
        $(this).append("<span class='displayNoneIndent displayNoneIndentNewWin' style='text-align:" + align + "'>" + newWinLabel + "</span>");
    });
}

function hashCode(str) {
    String.prototype.hashCode = function () {
        var hash = 0;
        if (this.length == 0) return hash;
        for (i = 0; i < this.length; i++) {
            char = this.charCodeAt(i);
            hash = ((hash << 5) - hash) + char;
            hash = hash & hash;
        }
        return hash;
    }

    return str.hashCode();
}

function accInitReWriteTable() {
    var breadCrumbLabel = "";
    if (accLangID == "EN") breadCrumbLabel = "Your location on the site";
    else if (accLangID == "AR") breadCrumbLabel = "موقعك على الموقع";
    else if (accLangID == "FR") breadCrumbLabel = "Votre position sur le site";
    else if (accLangID == "RU") breadCrumbLabel = "Ваше местоположение на сайте";
    else breadCrumbLabel = "מיקומך באתר";

    $(".breadCrumb").attr("aria-label", breadCrumbLabel);

    accSetImageTable();

    if ($("table.ms-listviewtable,table[class*='ms-rteTable-Design']").not("table.reWriteTable,table.notReWrite").length > 0) {
        accReWriteTable();
        $(window).resize(function () { accReWriteTableResize() });
    }
}

function accSetImageTable() {
    var tbl5 = $("table.ms-rteTable-Design5");
    if (tbl5.length <= 0) return;

    var tblLabel = "";
    if (accLangID == "EN") tblLabel = "Display table only";
    else if (accLangID == "AR") tblLabel = "عرض الجدول فقط";
    else if (accLangID == "FR") tblLabel = "Tableau d'affichage uniquement";
    else if (accLangID == "RU") tblLabel = "Отображать только таблицу";
    else tblLabel = "טבלה לתצוגה בלבד";

    tbl5.attr("role", "presentation").attr("aria-label", tblLabel).find("td").css("width", 100 / tbl5.find("tr:first td").length + "%");
}

function accReWriteTableResize() {
    if (!accIsMobile()) {
        $("table.reWriteTable").each(function (j) {
            var table = $(this);

            table.find("th.reWriteTH").remove();
            table.find("td.reWriteTD").remove();
            table.find("th.displayNone").removeClass("displayNone");
            table.find("td.displayNone").removeClass("displayNone");
            table.find("tr.reWrtieRow").remove();
            table.removeClass("reWriteTable").removeClass("reWriteTable" + j);
        });
        return;
    }

    if ($("table.reWriteTable").length <= 0) accReWriteTable();
}

function accReWriteTable() {
    if (!accIsMobile()) return;
   
    var openMoreLabel = "";
    if (accLangID == "EN") openMoreLabel = "Open more information";
    else if (accLangID == "AR") openMoreLabel = "افتح المزيد من المعلومات";
    else if (accLangID == "FR") openMoreLabel = "Ouvrir plus d'informations";
    else if (accLangID == "RU") openMoreLabel = "Открыть больше информации";
    else openMoreLabel = "פתח מידע נוסף";

    $("table.ms-listviewtable,table[class*='ms-rteTable-Design']").not("table.notReWrite").each(function (j) {
        var tHead = null;
        var tBody = null;
        var table = $(this)
        var thArray = new Array();

        if (table.find("thead").length <= 0) {
            tHead = table.find("tr:first-child");
            tBody = table.find("tr").not("tr:first-child,tr.megeraRow");
        }
        else {
            tHead = table.find("thead tr");
            tBody = table.find("tbody tr").not("tr.megeraRow");
        }

        if (tHead.find("th").length < 4) return;

        table.addClass("hiddenElement reWriteTable reWriteTable" + j);
        tHead.find("th").addClass("displayNone");
        tHead.find("th:nth-child(1),th:nth-child(2),th:nth-child(3)").removeClass("displayNone");
        tHead.append("<th class=reWriteTH>&nbsp;</th>");

        tHead.find("th.displayNone").not("th.megeraHead").each(function (i) {
            thArray.push($(this).text());
        });

        tBody.find("td").not("td[filter1=true],td[filter2=true]").addClass("displayNone");
        tBody.find("td:nth-child(1),td:nth-child(2),td:nth-child(3)").removeClass("displayNone");

        tBody.each(function (index) {
            var row = $(this);

            row.attr("index", index).append("<td class='reWriteTD reWriteTD" + index + "'><a class='reWriteButton fa fa-angle-down' href='javascript:accOpenReWriteRow(" + j + "," + index + ")' title='" + openMoreLabel + "' aria-label='" + openMoreLabel + "'></a></td>");
            row.after("<tr index=" + index + " class='reWrtieRow reWrtieRow" + index + " displayNone " + row.attr("class") + "' aria-hidden='true'><td colspan=20><div class='reWrtieData reWrtieData" + index + " displayNone'></div></td></tr>");

            var reWrtieData = table.find(".reWrtieData" + index);

            row.find("td.displayNone").not("td.megeraData,td.megeraButton").each(function (i) {
                //if ($(this).text() != "") {
                    reWrtieData.append("<h2>" + thArray[i] + "</h2><br/>");
                    reWrtieData.append($(this).html() + "<div class='itemHeightSpaceSmall'></div>");
                //}
            });

            row.find("td.megeraButtonStay").each(function () {
                reWrtieData.append("<div class='megeraButton megeraButtonMore'>" + $(this).html() + "</div>");
            });
        });
        table.removeClass("hiddenElement");
    });
}

function accOpenReWriteRow(j, index) {
    var table = $("table.reWriteTable" + j);
    var last = accGetAttributeValue(table.attr("last"));

    if (last != "") accCloseReWriteRow(j, last);

    table.attr("last", index);

    var openMoreLabel = "";
    if (accLangID == "EN") openMoreLabel = "Close more information";
    else if (accLangID == "AR") openMoreLabel = "أغلق المزيد من المعلومات";
    else if (accLangID == "FR") openMoreLabel = "Fermer plus d'infos";
    else if (accLangID == "RU") openMoreLabel = "Закрыть больше информации";
    else openMoreLabel = "סגו מידע נוסף";

    var row = table.find("tr.reWrtieRow" + index);
    row.removeClass("displayNone");
    row.find(".reWrtieData").slideDown("fast");
    table.find("td.reWriteTD" + index + " .reWriteButton").attr("href", "javascript:accCloseReWriteRow(" + j + "," + index + ")").attr("title", openMoreLabel).attr("aria-label", openMoreLabel).addClass("fa-angle-up").removeClass("fa-angle-down");
}

function accCloseReWriteRow(j, index) {
    var table = $("table.reWriteTable" + j);

    var openMoreLabel = "";
    if (accLangID == "EN") openMoreLabel = "Open more information";
    else if (accLangID == "AR") openMoreLabel = "افتح المزيد من المعلومات";
    else if (accLangID == "FR") openMoreLabel = "Ouvrir plus d'informations";
    else if (accLangID == "RU") openMoreLabel = "Открыть больше информации";
    else openMoreLabel = "פתח מידע נוסף";

    table.find("td.reWriteTD" + index + " .reWriteButton").attr("href", "javascript:accOpenReWriteRow(" + j + "," + index + ")").attr("title", openMoreLabel).attr("aria-label", openMoreLabel).addClass("fa-angle-down").removeClass("fa-angle-up")
    table.find("tr.reWrtieRow" + index + " .reWrtieData").slideUp("fast", function () {
        table.find("tr.reWrtieRow" + index).addClass("displayNone");
    });
}

function addSkipAreas() {
    $(".rightMenu").addClass("skipArea").attr("skipAreaType", "menu");

    $(".skipArea").each(function (index) {
        var cls = "skipArea" + index;
        var areaText = accGetAttributeValue($(this).attr("areaText"));
        var skipAreaType = accGetAttributeValue($(this).attr("skipAreaType"));

        if (skipAreaType == "menu") {
            if (accLangID == "EN") areaText = "Menu, ";
            else if (accLangID == "AR") areaText = "القائمة، ";
            else if (accLangID == "FR") areaText = "Menu, ";
            else if (accLangID == "RU") areaText = "Меню, ";
            else areaText = "תפריט, ";
            skipAreaType = "prefix";
        }

        if (areaText == "") skipAreaType = "prefix";

        if (skipAreaType == "prefix") {
            if (accLangID == "EN") areaText += "click to skip this area";
            else if (accLangID == "AR") areaText += "انقر لتخطي هذه المنطقة";
            else if (accLangID == "FR") areaText += "cliquez pour ignorer cette zone";
            else if (accLangID == "RU") areaText += "нажмите, чтобы пропустить эту область";
            else areaText += "לחץ לדילוג על אזור זה";
        }

        $(this).addClass(cls);
        addSkipArea("." + cls, areaText);
    });
}

function addSkipArea(areaID, areaText) {
    if ($(areaID).length <= 0) return;
    var skip = "skip" + areaID.replace(/\./gi, "").replace(/#/gi, "").replace(/ /gi, "");
    $(areaID).prepend($('<div class="displayNoneSkipContainer"><a class="displayNoneIndent displayNoneSkip" href="javascript:accDoAnchor(\'#' + skip + '\')">' + areaText + '</a></div>')).append('<a aria-hidden="true" href="javascript:void(0)" tabindex="-1" id="' + skip + '" name="' + skip + '"><span class="displayNoneIndent">' + skip + '</span></a>');
}

function accSetLangID() {
    var arrFR = new Array("/fr/", "/fra/", "/france/");
    var arrRU = new Array("/ru/", "/rus/", "/russian/");
    var arrAR = new Array("/ar/", "/arab/", "/arabic/");
    var arrEN = new Array("/en/", "/eng/", "/english/");
    var locationHref = document.location.href.toLowerCase();
   
    if (isLangInArray(locationHref, arrEN)) accLangID = "EN";
    else if (isLangInArray(locationHref, arrAR)) accLangID = "AR";
    else if (isLangInArray(locationHref, arrFR)) accLangID = "FR";
    else if (isLangInArray(locationHref, arrRU)) accLangID = "RU";
    else accLangID = "HE";
}

function isLangInArray(l, arr) {
    for (var i = 0; i < arr.length; i++) {
        if (l.indexOf(arr[i]) != -1) return true;
    }
    return false;
}

function isWidthChngeDetected() {
    if (accWinWidth == $(window).width()) return false;
    accWinWidth = $(window).width();
    return true;
}

function accConvertToMobileTelLink() {
    if (!accUseMobileTell || accIsAdmin() || !accIsMobile()) return;

    var arrNodesAfter = new Array();
    var arrNodesAppend = new Array();
    var arrValuesAfter = new Array();
    var arrValuesAppend = new Array();
    var notAllowClass = new Array(".fieldDescription", ".ms-formvalidation");
    var phoneRegxp = new Array(/ 0\d{9} /g, / 0\d{8} /g, /0\d{1,2}-\d{7}/g, /0\d{1,2}-\d{3}-\d{4}/g, /\d{1}-\d{3}-\d{3}-\d{3}/g);
    var notAllowTags = new Array("A[href*='tel://'] *", "A", "SCRIPT", "IMG", "INPUT", "TEXTAREA", "STYLE", "LINK", "BUTTON", "TR", "THEAD", "TBODY", "FILE", "BR");

    try {
        $("#siteOnly *").not(notAllowTags.join(",") + "," + notAllowClass.join(",")).each(function () {
            var thisChildNodes = $(this)[0].childNodes;

            for (var x = 0; x < thisChildNodes.length; x++) {
                var found = false;
                var h = $(thisChildNodes[x]).html();
                var t = $(thisChildNodes[x]).text();

                if (isUndefined(h)) h = t;

                if (t == h) {
                    if (h != "" && isAllowElement(notAllowTags, notAllowClass, thisChildNodes[x])) {
                        for (var i = 0; i < phoneRegxp.length; i++) {
                            var currentFound = phoneRegxp[i].test(h);
                            found = found | currentFound;
                            if (currentFound) h = h.replace(phoneRegxp[i], "<a href='tel://$&'>$&</a>");
                        }
                        if (found) {
                            if (!isUndefined($(thisChildNodes[x]).html()))
                                $(thisChildNodes[x]).html(h);
                            else {
                                thisChildNodes[x].nodeValue = "";
                                if (x == 0) {
                                    arrNodesAppend.push($(this));
                                    arrValuesAppend.push(h);
                                }
                                else {
                                    arrNodesAfter.push($(thisChildNodes[x - 1]));
                                    arrValuesAfter.push(h);
                                }
                            }
                        }
                    }
                }
            }
        });

        for (var i = 0; i < arrNodesAfter.length; i++) arrNodesAfter[i].after(arrValuesAfter[i]);
        for (var i = 0; i < arrNodesAppend.length; i++) arrNodesAppend[i].prepend(arrValuesAppend[i]);

        var changeFont = accGetCookie("changeFont");
        var changeBackground = accGetCookie("changeBackground");

        if (changeFont != "" || changeBackground != "") {
            $("#siteOnly a[href*='tel://'][CFS!='true'][CBC!='true']").each(function () {
                var el = $(this)[0];
                accChangeFontSizeAfter(changeFont, el);
                accChangeBackgroundAfter(changeBackground, el);
            });
        }
    }
    catch (err) { }
}

function isAllowElement(notAllowTags, notAllowClass, el) {
    if (accGetArrayIndex2(notAllowTags, el.tagName) != -1) return false;
    for (var i = 0; i < notAllowClass.length; i++) if ($(el).hasClass(notAllowClass[i].replace(".", ""))) return false;
    return true;
}

function accSetSearchTitle() {
    if (document.location.href.toString().toLowerCase().indexOf("/search/") != -1 && accGetRequestValue("k") != "" && $(".article-content h2").length > 0) {
        $($(".article-content h2")[0]).text($($(".article-content h2")[0]).text() + " '" + decodeURI(accGetRequestValue("k")) + "'");
    }
}

function isAdmin() { return accIsAdmin(); }
function getCookie(cookieName) { return accGetCookie(cookieName); }
function isUndefined(value) { return (typeof value == "undefined"); }
function mySwitchDirection(thisObj) { thisObj.css("direction", myGetDirection(thisObj, false)); }
function blurInvalid(input) {    
    if (input.val() == "") {
        if (!accInitSignaturePadActive) setUnValidControl(input);
    }
    else setValidControl(input);
    
    //input.val() == "" ? setUnValidControl(input) : setValidControl(input);
}
function accIsMobile() { return (/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)); }
function accIsAdmin() { return $("#sharepointLoginDiv").html().toLowerCase().indexOf("signout.aspx") != -1; }
function accGetAttributeValue(attr) { return (typeof attr !== typeof undefined && attr !== false) ? attr : ""; }
function accCalcHeight() { $("#siteOnly").css("height", $(window).height() - $("#sharepointLoginDiv").height()); }
function setValidControl(input) { input.removeAttr("aria-invalid").css("border-color", "").css("border-width", ""); }
function myClearDirection(thisObj) { if (thisObj.val() == "") thisObj.css("direction", myGetDirection(thisObj, true)); }
function accStopFlickers() { $(".flickerPlace").each(function () { eval("stopFlicker" + $(this).attr("UniqueID") + "()"); }); }
function accStartFlickers() { $(".flickerPlace").each(function () { eval("startFlicker" + $(this).attr("UniqueID") + "()"); }); }
function setUnValidControl(input) { input.attr("aria-invalid", "true").css("border-color", "#D90000").css("border-width", "2px"); }
function accRemoveNewWinSharePointLinks() { $("a[onclick]").filter("[onclick*='EditLink2('],[onclick*='OpenPopUpPage(']").removeAttr("onclick").attr("target", "_self"); }
function accStripHTML(str) { return str.replace(/<br>/gi, "\n").replace(/<p.*>/gi, "\n").replace(/<a.*href="(.*?)".*>(.*?)<\/a>/gi, " $2 (Link->$1) ").replace(/<(?:.|\s)*?>/g, ""); }
function setAccEventsNoDir(envControl, control) { $(envControl + " " + control + "[aria-required='true']").each(function () { $(this).blur(function () { blurInvalid($(this)) }); }); }
function accStopMarquees() { $(".setMarqueePlayPause").each(function () { eval("stopMarquee" + $(this).attr("UniqueID") + "(); isActiveButton" + $(this).attr("UniqueID") + "=true;"); }); }
function accStartMarquees() { $(".setMarqueePlayPause").each(function () { eval("isActiveButton" + $(this).attr("UniqueID") + "=false; startMarquee" + $(this).attr("UniqueID") + "();"); }); }

function accGetGoogleMap(data, index) {
    var accStreetViewModeArray = new Array("Panorama", "Overlay");
    var accZoomPanTypeArray = new Array("Small", "Large", "SmallZoom", "Small3D", "Large3D");
    var accGoogleMapViewArray = new Array("Normal", "Satellite", "Hybrid", "Physical", "MoonElevation", "MoonVisible", "MarsElevation", "MarsVisible", "MarsInfrared", "SkyVisible", "Satellite3D", "MapMakerNormal", "MapMakerHybrid");

    var googleMapID = "googleMap" + (index + 1);
    var targetGoogleMap = $("#googleMapContainer" + index);

    if (targetGoogleMap.length <= 0) return;

    if (data == "") {
        targetGoogleMap.html("");
        return;
    }

    data = accStripHTML(data).split(";#");

    var zoom = data[0];
    var address = data[1];
    var boxWidth = data[2];
    var latitude = data[3];
    var boxHeight = data[4];
    var longitude = data[5];
    var languageCode = data[6];
    var addressDefault = data[7];
    var backgroundColor = data[8];
    var zoomPanType = accGetArrayIndex(accZoomPanTypeArray, data[9]);
    var googleMapView = accGetArrayIndex(accGoogleMapViewArray, data[10]);
    var streetViewMode = accGetArrayIndex(accStreetViewModeArray, data[11]);
    var key = data[12];

    if (key == "" || key == "AIzaSyCxnfYMh62yC1XhMthGMAMY-1zvRnfHtQA") key = "AIzaSyC-kl2WmImNWFoJdVVUf6RqH4dYekPjDTU";

    targetGoogleMap.html("<div id=\"" + googleMapID + "\" class=\"googleMapItemList googleMapItemList" + index + "\"><iframe scrolling=\"no\" marginheight=\"0px\" marginwidth=\"0px\" allowfullscreen=\"true\" frameborder=\"0\" width=\"100%\" height=\"" + boxHeight + "px\" src=\"https://www.google.com/maps/embed/v1/place?language=" + languageCode + "&key=" + key + "&q=" + address + "\"></iframe></div><div class=\"listItemMapCaption\"><a target=\"_blank\" href=\"https://www.google.co.il/maps/place/" + address + "?hl=" + languageCode + "\">" + address + "</a></div>");   
}

function accGetArrayIndex(arr, value) {
    for (var i = 0; i < arr.length; i++) if (arr[i] == value) return i;
    return 0;
}

function accGetArrayIndex2(arr, value) {
    for (var i = 0; i < arr.length; i++) if (arr[i] == value) return i;
    return -1;
}

function accOpenMobMenu() {    
    if ($(".mobileMenuInner").css("display") == "block")
        $(".mobileMenuInner").hide("slow").attr("aria-hidden", "true");
    else
        $(".mobileMenuInner").show("slow").attr("aria-hidden", "false");
}

function accFixMobMenuWidth() { $(".mobileMenu").css("width", $(document.body).width() - 10 + "px"); }

function accCalcHeightActive() {
    accCalcHeight();
    setTimeout(function () { accCalcHeight(); }, 1000);
}

function accDoFastLogin(e) {
    if (window.event) e = window.event;
    if (!(e.altKey && e.ctrlKey)) return;
    if (e.keyCode != 76) return;
    document.location.href = "/_layouts/Authenticate.aspx?Source=" + document.location.pathname;
}

function accSetSearchEvents(envClass) {
    if ($("." + envClass).length <= 0) return;

    $("." + envClass + " a").attr("href", "javascript:void(0)").click(function (e) { accDoSearch($("." + envClass + " input")) });
    $("." + envClass + " input").val(decodeURI(accGetRequestValue("k"))).keypress(function (e) { accKeySearch($(this), e) });
}

function accKeySearch(serachBox, e) {
    if (e.keyCode == 13) {
        e.preventDefault();
        accDoSearch(serachBox);
    }
}
function accSetSearchValue() {
    accSetSearchEvents("searchArea");
    accSetSearchEvents("searchArea2");
    accSetSearchEvents("searchArea3");
}

function accDoSearch(serachBox) {
    if (serachBox.val() != "") {
        document.location.href = accSearchPage + "?k=" + encodeURI(serachBox.val());
        return;
    }

    alert(accScriptTitle[0]);
    serachBox[0].focus();
}

function accGetRequestValue(name) {
    var results = new RegExp("[\\?&]" + name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]") + "=([^&#]*)", "i").exec(window.location.href);
    return results == null ? "" : results[1];
}

function accKillAria() {
    $("*[role='menu'],*[role='menubar'],*[role='menuitem'],*[role='tree'],*[role='treeitem']").removeAttr("role");
    $(".FloatingMenu li[aria-haspopup]").removeAttr("aria-haspopup");
}

function accFixAccessibility() {
    //$("*[role='menu'],*[role='menubar'],*[role='menuitem'],*[role='tree'],*[role='treeitem']").bind('DOMSubtreeModified', function () { accKillAria();})

    accKillAria();
    fixExpCollGroup();
    accSetNewWinIndecation();

    $(".siteOnly table:not([class^='ms-']):not([role]),.siteOnly .divTable:not([role]),.siteOnly .divTableFull:not([role])").attr("role", "presentation");

    $(".siteOnly div[dir='None']").removeAttr("dir");
    $(".siteOnly span[dir='None']").removeAttr("dir");
    $(".siteOnly table[dir='None']").removeAttr("dir");

    $(".siteOnly table[summary]").removeAttr("summary");
    $(".siteOnly iframe:not([title])").attr("title", "");

    $(".siteOnly a[title] img:not([alt])").each(function () { $(this).attr("alt", $(this).parent().attr("title")); });    
    $(".siteOnly img[alt]:not([class='ms-commentexpandrtl-icon'],[longdesc])").each(function () { $(this).attr("title", $(this).attr("alt")); });

    $(".divTableCell, #skipMain").attr("role", "presentation");

    if (!accIsAdmin()) {
        var align = "right";
        var label = "קישור ריק";

        if (accLangID == "EN" || accLangID == "FR" || accLangID == "RU") align = "left";

        $("#topMobMenuRoot").attr("role", "");
        $("img:not([alt]),#imgPrefetch img").attr("alt", "");

        $("a:empty").each(function () {
            if (accGetAttributeValue($(this).attr("aria-label"))) label = $(this).attr("aria-label");
            else if (accGetAttributeValue($(this).attr("title"))) label = $(this).attr("title");
            else if (accGetAttributeValue($(this).attr("id"))) label = $(this).attr("id");

            $(this).append("<span style='text-align:" + align + "' class='displayNoneIndent'>" + label + "</span>");
        });
    }

    if ($(".smartPager").length > 0 && $(".smartPager .displayNoneIndent").length == 0) {
        $(".smartPager").prepend("<h3 class='displayNoneIndent'>דיפדוף לעמודים נוספים</h3>");
        $(".smartPager a").each(function () { $(this).attr("aria-label", $(this).attr("title")) });
    }

    $(".ms-acal-month-top nobr span").each(function () { $(this).html($(this).html().replace("&nbsp;", " ")); });
    var acalHeader = $(".ms-acal-header .ms-acal-display");
    if (acalHeader.length > 0) {        
        acalHeader.parent().append("<h2 class='calTitle' id='" + acalHeader.attr("id") + "'>" + acalHeader.text() + "</h2>");
        acalHeader.remove();
    }

    //$(".siteOnly a[target='_blank']:not([aria-haspopup])").attr("aria-haspopup", "true");
    accFixTreeMenu();
    setTimeout(function () { accFixTreeMenu(); }, 2000);
    try { extraFixAccessibility(); } catch (err) { };
}

function accTreeMenuContentChanged(thisEL) {
    if (accGetAttributeValue(thisEL.attr("round")) == "") thisEL.attr("round", "0");
    if (accGetAttributeValue(thisEL.attr("round")) == "5") return;

    thisEL.parent().find(".x-tree-node-el").each(function () { accSetTreeMenuClick($(this)); });
    thisEL.attr("round", accGetAttributeValue(parseInt(thisEL.attr("round"))) + 1);

    //$(".x-tree-root-ct .x-tree-node-el").each(function () { accSetTreeMenuClick($(this)); });
}

function accTreeMenuContentChangedTimeOut(thisEL) {
    setTimeout(function () { accTreeMenuContentChanged(thisEL) }, 500);
    setTimeout(function () { accTreeMenuContentChanged(thisEL) }, 1000);
    setTimeout(function () { accTreeMenuContentChanged(thisEL) }, 1500);
}

function accFixTreeMenu() {
    if ($(".x-tree-root-ct").length == 0) return;

    $(".x-tree-root-ct").each(function () {
        if ($(this).attr("irole") == "tree") return;

        $(this).find("*[hidefocus]").removeAttr("hidefocus");
        $(this).find("*[unselectable]").removeAttr("unselectable");
        $(this).find("*[tabindex]").not("img").removeAttr("tabindex");

        $(this).attr("irole", "tree").attr("aria-label", "תפריט עץ");
        $(this).find("ul").attr("role", "group").attr("aria-hidden", "true");
        $(this).find("li").attr("role", "treeitem").attr("aria-expanded", "false");       

        $(this).find(".x-tree-node-el").each(function () {
            accSetTreeMenuClick($(this));
            $(this).bind("click", function () { accTreeMenuContentChangedTimeOut($(this)) });
        });
    });

    //$(".x-tree-root-ct").unbind("DOMNodeInserted").bind("DOMNodeInserted", function () { accTreeMenuContentChanged(); });
}

function accSetTreeMenuClick(thisEL) {
    var ul = thisEL.next();
    var li = thisEL.parent();
  
    var changeFont = accGetCookie("changeFont");
    var changeBackground = accGetCookie("changeBackground");

    if (accGetCookie("underlineLinks") == "1") accUnderlineLinks(1);
    if (changeFont != "") accChangeFontSizeAfter(changeFont, thisEL.parent()[0]);
    if (changeBackground != "") accChangeBackgroundAfter(changeBackground, thisEL.parent()[0]);    

    ul.find("ul").attr("role", "group").attr("aria-hidden", "true");
    ul.find("li").attr("role", "treeitem").attr("aria-expanded", "false");
    ul.find("li .x-tree-node-el").each(function () {
        $(this).bind("click", function (e) {
            var div = $(this);
            setTimeout(function () { accSetTreeMenuClick(div) }, 1000);
            accTreeMenuContentChangedTimeOut(div);
        });
    });

    thisEL.find("*[hidefocus]").removeAttr("hidefocus");
    thisEL.find("*[unselectable]").removeAttr("unselectable");
    thisEL.find("*[tabindex]").not("img").removeAttr("tabindex");

    if (ul.css("display") == "none") {
        ul.attr("aria-hidden", "true");
        li.attr("aria-expanded", "false");
        accSetTreeMenuImages(thisEL, "פתח תפריט");
    }
    else {
        ul.attr("aria-hidden", "false");
        li.attr("aria-expanded", "true");
        accSetTreeMenuImages(thisEL, "סגור תפריט");
        if (ul.find("li").length <= 0) ul.attr("aria-hidden", "true");
    }
}

function accTreeMenuImageKeyPress(thisImg, thisEL, e) {
    if (e.which == 13) {
        e.preventDefault();
        thisEL.trigger("click");
        thisImg[0].focus();
        accTreeMenuContentChanged(thisEL);
    }
}

function accTreeMenuImageClick(thisImg, thisEL, e) {
    e.preventDefault();
    thisEL.trigger("click");
    accTreeMenuContentChanged(thisEL);
    setTimeout(function () { thisImg[0].focus() }, 1)
}

function accSetTreeMenuImages(thisEL, ttl) {
    thisEL.find("img").not(".x-tree-elbow-line, .x-tree-elbow, .x-tree-elbow-end, .x-tree-elbow-start").each(function () {
        if ($(this).css("display") != "none") {
            $(this)
       			.unbind("click").unbind("keypress")
        		.click(function (e) { accTreeMenuImageClick($(this), thisEL, e) })
        		.keypress(function (e) { accTreeMenuImageKeyPress($(this), thisEL, e) })
        		.attr("role", "button").attr("tabindex", "0").attr("title", ttl).attr("alt", ttl).attr("aria-label", ttl);
        }
        if ($(this).css("display") == "none" || $(this).width() == 0)
            $(this).unbind("click").unbind("keypress").attr("aria-hidden", "true").removeAttr("role").removeAttr("tabindex").attr("title", "").attr("alt", "");
    });

    thisEL.find(".x-tree-node-indent").unbind("click").unbind("keypress").attr("aria-hidden", "true").removeAttr("role").removeAttr("tabindex").attr("title", "").attr("alt", "");
    thisEL.find(".x-tree-node-indent *").each(function () { $(this).unbind("click").unbind("keypress").attr("aria-hidden", "true").removeAttr("role").removeAttr("tabindex").attr("title", "").attr("alt", ""); });
    thisEL.find(".x-tree-elbow-line").unbind("click").unbind("keypress").attr("aria-hidden", "true").removeAttr("role").removeAttr("tabindex").attr("title", "").attr("alt", "");;
    thisEL.find(".x-tree-elbow").unbind("click").unbind("keypress").attr("aria-hidden", "true").removeAttr("role").removeAttr("tabindex").attr("title", "").attr("alt", "");;
    thisEL.find(".x-tree-elbow-end").unbind("click").unbind("keypress").attr("aria-hidden", "true").removeAttr("role").removeAttr("tabindex").attr("title", "").attr("alt", "");;
    thisEL.find(".x-tree-elbow-start").unbind("click").unbind("keypress").attr("aria-hidden", "true").removeAttr("role").removeAttr("tabindex").attr("title", "").attr("alt", "");;
}

function fixExpCollGroup() {
    var arrExpCollGroup = new Array();
    var arrExpCollGroupParent = new Array();
    var index = 1;

    $(".ms-gb a[onclick*='javascript:ExpCollGroup(']").each(function () {
        var a = $("<a id='expCollGroup" + index + "' href='javascript:#'></a>");
        var cls1 = $(this).find("span").attr("class");
        var cls2 = $(this).find("span img").attr("class");

        a.attr("onclick", "accExpCollGroupTitle(" + index + ");" + $(this).attr("onclick")).html("<span class='" + cls1 + "'><img class='" + cls2 + "' /></span>" + $(this).parent().text());

        if (cls2 == "ms-commentexpandrtl-icon")
            a.find("img").attr("alt", "הרחב").attr("title", "הרחב").attr("id", $(this).find("img").attr("id")).attr("src", $(this).find("img").attr("src"));
        else
            a.find("img").attr("alt", "כווץ").attr("title", "כווץ").attr("id", $(this).find("img").attr("id")).attr("src", $(this).find("img").attr("src"));

        arrExpCollGroup.push(a);
        arrExpCollGroupParent.push($(this).parent());
        index++;
    });

    for (var i = 0; i < arrExpCollGroupParent.length; i++) {
        arrExpCollGroupParent[i].html("");
        arrExpCollGroupParent[i].append(arrExpCollGroup[i]);
    }
}

function accExpCollGroupTitle(index) {
    setTimeout(function () { accExpCollGroupTitleActive(index) }, 500);
}

function accExpCollGroupTitleActive(index) {
    var obj = $("#expCollGroup" + index + " img");
    if (obj.attr("class") == "ms-commentexpandrtl-icon")
        obj.attr("alt", "הרחב").attr("title", "הרחב");
    else
        obj.attr("alt", "כווץ").attr("title", "כווץ");
}

function accPageLoadSharePointLinks() {
    accRemoveSharePointLinks();
    accRemoveNewWinSharePointLinks();
    setTimeout(function () { accRemoveSharePointLinks(); }, 2000);
    setTimeout(function () { accRemoveSharePointLinks(); }, 4000);
}

function accRemoveSharePointLinks() {
    $("a[onclick]").filter("[onclick*='return DispEx'],[onclick*='DispDocItemExWithServerRedirect']").removeAttr("onclick").removeAttr('onfocus').removeAttr("onmousedown").attr("target", "_blank");
    accRemoveNewWinSharePointLinks();
}

function accResetAutoSaveForm() {
    accDeleteCookie(accAutoSaveFormCookieID);
    document.location.href = document.location.href;
}

function accSetAutoSaveForm() {
    var saveForm = accGetCookie(accAutoSaveFormCookieID);
    var val = saveForm.split(accAutoSaveDelimiterFields);

    for (var i = 0; i < val.length; i++) {
        var arr = val[i].split(accAutoSaveDelimiterValues);
        var lbl = arr[0];
        var newValue = arr[1];
        var parentFieldlabel = arr[2];

        if (lbl == "" || newValue == "") continue;

        var field = accGetAutoSaveField(lbl, parentFieldlabel);
        if (field != null) {
            var type = accGetAttributeValue(field.attr("type"));

            if (type == "radio" || type == "checkbox") {
                if (newValue == "true") field.prop("checked", true);
                else field.prop("checked", false);
            }
            else field.val(newValue);
        }
    }
}

function accGetAutoSaveField(lbl, parentFieldlabel) {
    var returnField = null;

    $(".formGeneratorEnvelope input[type!='file'],.formGeneratorEnvelope textarea,.formGeneratorEnvelope select").each(function () {
        if (returnField != null) return;
        thisEL = $(this);
        if (accGetAutoSaveFieldLabel(thisEL) == lbl && parentFieldlabel == accGetAttributeValue(thisEL.attr("parentFieldlabel"))) returnField = thisEL;
    });
    return returnField;
}

function accSetAutoSaveBlurField(thisEL) {
    var found = false;
    var newVal = thisEL.val();
    var parentFieldlabel = "";
    var id = thisEL.attr("id");
    var lbl = accGetAutoSaveFieldLabel(thisEL);
    var type = accGetAttributeValue(thisEL.attr("type"));
    var saveForm = accGetCookie(accAutoSaveFormCookieID);
    var val = saveForm.split(accAutoSaveDelimiterFields);

    if (type == "radio" || type == "checkbox") {
        newVal = thisEL.prop("checked");
        parentFieldlabel = thisEL.attr("parentFieldlabel")
    }

    for (var i = 0; i < val.length; i++) {
        var arr = val[i].split(accAutoSaveDelimiterValues);
        if (arr[0] == lbl && arr[2] == parentFieldlabel) {
            arr[1] = newVal;
            arr[2] = parentFieldlabel;
            val[i] = arr.join(accAutoSaveDelimiterValues);
            found = true;
            break;
        }
    }

    if (!found) val.push(new Array(lbl, newVal, parentFieldlabel).join(accAutoSaveDelimiterValues));

    if (type == "radio") {
        $("input[id!='" + id + "'][name='" + thisEL.attr("name") + "']").each(function () {
            lbl = accGetAutoSaveFieldLabel($(this));
            for (var i = 0; i < val.length; i++) {
                var arr = val[i].split(accAutoSaveDelimiterValues);
                if (arr[0] == lbl && $(this).attr("parentFieldlabel") == parentFieldlabel) {
                    arr[1] = "false";
                    val[i] = arr.join(accAutoSaveDelimiterValues);
                    break;
                }
            }
        });
    }

    accSetCookie(accAutoSaveFormCookieID, val.join(accAutoSaveDelimiterFields), 30);
}

function accGetAutoSaveFieldLabel(thisEL) {
    var lbl = accGetAttributeValue(thisEL.attr("aria-label"));

    if (lbl == "") {
        lbl = $("label[for='" + thisEL.attr("id") + "']").clone();
        lbl.find(".ms-formvalidation").remove();
        lbl = lbl.text();
    }
    return lbl;
}

function accFixForm() {   
    if ($(".formGeneratorEnvelope,.surveyStatisticsEnvelope").length <= 0) return;

    $(".formGeneratorEnvelope *[disabled]").each(function () {
        $(this).attr("disabled", "false");
        $(this).prop("disabled", "false");
        $(this).removeProp("disabled");
        $(this).removeAttr("disabled");
    });    

    var align = "right";
    var mustLabel = "שדה חובה";
    
    if (accLangID == "EN") mustLabel = "Required field";
    else if (accLangID == "AR") mustLabel = "حقل مطلوب";
    else if (accLangID == "FR") mustLabel = "Champ obligatoire";
    else if (accLangID == "RU") mustLabel = "Обязательное поле";

    if (accLangID == "EN" || accLangID == "FR" || accLangID == "RU") align = "left";

    $(".formGeneratorEnvelope label span.ms-formvalidation").each(function () {
        if ($(this).next().hasClass("displayNoneIndentMustField")) return;
        $(this).attr("aria-label", mustLabel).attr("title", mustLabel).after("<span style='text-align:" + align + "' class='displayNoneIndent displayNoneIndentMustField'>" + mustLabel + "</span>");
    });   

    $(".formGeneratorEnvelope input[type='file']").change(function () { accFileChange($(this)) });    

    var fields = $(".formGeneratorEnvelope input[type!='file'],.formGeneratorEnvelope textarea,.formGeneratorEnvelope select");

    if (fields.length > 0 && accGetAttributeValue($(".formGeneratorEnvelope").attr("autoSaveActive")) == "true") {
        if (accGetCookie(accAutoSaveFormCookieID) != "") {
            var autoSaveEnv = accGetAttributeValue($(".formGeneratorEnvelope[autoSaveText!='']").attr("autoSaveText"));

            if (autoSaveEnv == "") {
                if (accLangID == "EN") autoSaveEnv = "<div class='autoSaveEnv displayNone'><div class='autoSaveInner'><h2 class=ms-rteElement-H2B>Automatic save</h2>It was found that this form started/completed data entry.<br/>You can: <a href='javascript:accSetAutoSaveForm()'>Load the data</a> or <a href='javascript:accResetAutoSaveForm()'>Delete the data</a></div></div>";
                else if (accLangID == "AR") autoSaveEnv = "<div class='autoSaveEnv displayNone'><div class='autoSaveInner'><h2 class=ms-rteElement-H2B>حفظ تلقائي</h2>وقد وجد أن هذا النموذج بدأ/أكمل إدخال البيانات.<br/>تستطيع: <a href='javascript:accSetAutoSaveForm()'>تحميل البيانات</a> او <a href='javascript:accResetAutoSaveForm()'>حذف البيانات</a><div></div>";
                else if (accLangID == "FR") autoSaveEnv = "<div class='autoSaveEnv displayNone'><div class='autoSaveInner'><h2 class=ms-rteElement-H2B>Sauvegarde automatique</h2>Il a été constaté que ce formulaire a commencé/complété la saisie de données.</br>vous pouvez: <a href='javascript:accSetAutoSaveForm()'>Charger les données</a> ou <a href='javascript:accResetAutoSaveForm()'>Supprimer les données</a></div></div>";
                else if (accLangID == "RU") autoSaveEnv = "<div class='autoSaveEnv displayNone'><div class='autoSaveInner'><h2 class=ms-rteElement-H2B>Автоматическое сохранение</h2>Выяснилось, что эта форма начала/завершила ввод данных.</br>Вы можете: <a href='javascript:accSetAutoSaveForm()'>Загрузите данные</a> или <a href='javascript:accResetAutoSaveForm()'>Удалить данные</a></div></div>";
                else autoSaveEnv = "<div class='autoSaveEnv displayNone'><div class='autoSaveInner'><h2 class=ms-rteElement-H2B>שמירה אוטומטית</h2>נמצא כי בטופס זה החל/הושלם הזנת נתונים.</br>באפשרותך: <a href='javascript:accSetAutoSaveForm()'>לטעון את הנתונים השמורים</a> או <a href='javascript:accResetAutoSaveForm()'>למחוק את הנתונים השמורים</a></div></div>";
            }

            $(".formGeneratorEnvelope").prepend(autoSaveEnv);
            $(".formGeneratorEnvelope .autoSaveEnv").show("fast").attr("aria-hidden", "false");
        }

        fields.each(function () {
            if ($(this).parent().parent().hasClass("signatureControl")) return;

            var type = accGetAttributeValue($(this).attr("type"));
            if (type == "radio" || type == "checkbox") $(this).attr("parentFieldlabel", $(this).parent().parent().parent().parent().parent().parent().parent().attr("fieldlabel"));

            $(this).blur(function () { accSetAutoSaveBlurField($(this)) })
        });
    }
    
    var regEx = /(\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)/;
    $(".formGeneratorEnvelope .fieldDescription").filter(function () { return $(this).html().match(regEx) }).each(function () {
        $(this).html($(this).html().replace(regEx, "<a href=\"mailto:$1\">$1</a>"));
    });
   
    $(".formGeneratorEnvelope .fieldDescription").each(function () {        
        var txt = $(this).html();
        var arr2 = new Array();

        txt = txt.replace(/\r/g, "<br/>");
        txt = txt.replace(/\n/g, "<br/>");
        arr = txt.split("<br/>");

        for (var i = 1; i < arr.length - 1; i++) arr2.push(arr[i]);        

        $(this).html(arr2.join("<br/>"));
    });

    setAccEvents(".signatureControl", "input");

    setValidationAndAcc(".formGeneratorEnvelope");
    if ($(".formGeneratorEnvelope .signatureControl .ms-formvalidation:eq(1):not(:empty)").length > 0) setTheErr($(".signatureControl input"), $(".formGeneratorEnvelope .signatureControl .ms-formvalidation:eq(1)"));
                          
    setValidationAndAcc(".surveyStatisticsEnvelope");
    if ($(".surveyStatisticsEnvelope .signatureControl .ms-formvalidation:eq(1):not(:empty)").length > 0) setTheErr($(".signatureControl input"), $(".formGeneratorEnvelope .signatureControl .ms-formvalidation:eq(1)"));       

    alertErr(accHtmlDialog, accFirstFocus);

    $(".formGeneratorEnvelope *[fieldtype='CheckBoxChoiceField'],.formGeneratorEnvelope *[fieldtype='RadioButtonChoiceField']").each(function () {
        $(this).attr("aria-label", $(this).attr("fieldlabel")).attr("role", "group");
        var des = $(this).parent().parent().find(".fieldDescription");
        if (des.length > 0) $(this).find("input").attr("aria-describedby", des.attr("id"));
    });
}

function accFileChange(input) {
    try {
        var files = input[0].files;
        var label = "קבצים שיצורפו לטופס זה";

        if (accLangID == "EN") label = "Files to be attached to this form";
        else if (accLangID == "AR") label = "الملفات المراد إرفاقها بهذا النموذج";
        else if (accLangID == "FR") label = "Fichiers à joindre à ce formulaire";
        else if (accLangID == "RU") label = "Файлы для прикрепления к этой форме";
        
        input.parent().find(".filesUploads").remove();
        if (files.length <= 0) return;

        var ul = $("<ul></ul>");
        var filesUploads = $("<div class='filesUploads'></div>");

        filesUploads.append("<h2 class='displayNoneIndent'>" + label + "</h2>");
        filesUploads.append(ul);
        input.after(filesUploads);

        for (var i = 0; i < files.length; i++) ul.append("<li>" + files[i].name + "</li>");
    }
    catch (err) { }
}

function accInitSignaturePad(sigPadID) {
    var sigPad = $(".sigPad" + sigPadID);
    if (sigPad.length <= 0) return;

    var labels = new Array();
    if (accLangID == "EN") labels = new Array("Clear signature", "Signature surface","Accessible signature");
    else if (accLangID == "AR") labels = new Array("توقيع واضح", "سطح التوقيع", "توقيع يمكن الوصول إليها");
    else if (accLangID == "FR") labels = new Array("Signature claire", "Surface signature","Signature accessible");
    else if (accLangID == "RU") labels = new Array("Очистить подпись", "Поверхность подписи","Доступная подпись");

    if (labels.length > 0) {        
        sigPad.parent().find(".clearButton a").html(labels[0]);
        sigPad.parent().find(".pad").attr("aria-label", labels[1]);
        sigPad.find("label").html('<input onclick="accSignaturePadRegenerate(\'' + sigPadID + '\')" type="checkbox"> ' + labels[2]);
    }

    sigPad.signaturePad({ output: "", clear: "", onDraw: function () { accInitSignaturePadActive = true }, onDrawEnd: function () { accInitSignaturePadActive = false; accSetImageData(sigPadID) }, drawOnly: true, validateFields: false, lineWidth: 0, defaultAction: 'drawIt', penWidth: 2, drawBezierCurves: true, variableStrokeWidth: true, lineTop: 200 });
    sigPad.find("canvas").mouseenter(function () { accInitSignaturePadActive = true });
    sigPad.find("canvas").mouseleave(function () { accInitSignaturePadActive = false });		

    var val = sigPad.parent().find(".input").val();
    if (val != "") {
        var defaultSig = '[{"lx":119,"ly":46,"mx":119,"my":45},{"lx":121,"ly":45,"mx":119,"my":46},{"lx":122,"ly":45,"mx":121,"my":45},{"lx":123,"ly":46,"mx":122,"my":45},{"lx":124,"ly":47,"mx":123,"my":46},{"lx":125,"ly":49,"mx":124,"my":47},{"lx":126,"ly":50,"mx":125,"my":49},{"lx":127,"ly":51,"mx":126,"my":50},{"lx":128,"ly":52,"mx":127,"my":51},{"lx":128,"ly":54,"mx":128,"my":52},{"lx":130,"ly":56,"mx":128,"my":54},{"lx":130,"ly":57,"mx":130,"my":56},{"lx":131,"ly":58,"mx":130,"my":57},{"lx":132,"ly":59,"mx":131,"my":58},{"lx":133,"ly":60,"mx":132,"my":59},{"lx":134,"ly":61,"mx":133,"my":60},{"lx":134,"ly":62,"mx":134,"my":61},{"lx":134,"ly":63,"mx":134,"my":62},{"lx":134,"ly":64,"mx":134,"my":63},{"lx":135,"ly":65,"mx":134,"my":64},{"lx":136,"ly":66,"mx":135,"my":65},{"lx":137,"ly":66,"mx":136,"my":66},{"lx":138,"ly":66,"mx":137,"my":66},{"lx":138,"ly":64,"mx":138,"my":66},{"lx":139,"ly":64,"mx":138,"my":64},{"lx":140,"ly":62,"mx":139,"my":64},{"lx":141,"ly":60,"mx":140,"my":62},{"lx":143,"ly":58,"mx":141,"my":60},{"lx":144,"ly":56,"mx":143,"my":58},{"lx":144,"ly":54,"mx":144,"my":56},{"lx":146,"ly":52,"mx":144,"my":54},{"lx":147,"ly":50,"mx":146,"my":52},{"lx":148,"ly":48,"mx":147,"my":50},{"lx":150,"ly":46,"mx":148,"my":48},{"lx":152,"ly":44,"mx":150,"my":46},{"lx":152,"ly":43,"mx":152,"my":44},{"lx":154,"ly":42,"mx":152,"my":43},{"lx":156,"ly":40,"mx":154,"my":42},{"lx":156,"ly":39,"mx":156,"my":40},{"lx":157,"ly":38,"mx":156,"my":39},{"lx":157,"ly":37,"mx":157,"my":38},{"lx":157,"ly":36,"mx":157,"my":37},{"lx":158,"ly":36,"mx":157,"my":36},{"lx":159,"ly":34,"mx":158,"my":36},{"lx":160,"ly":33,"mx":159,"my":34},{"lx":161,"ly":32,"mx":160,"my":33},{"lx":161,"ly":31,"mx":161,"my":32},{"lx":162,"ly":31,"mx":161,"my":31},{"lx":163,"ly":29,"mx":162,"my":31},{"lx":164,"ly":28,"mx":163,"my":29},{"lx":165,"ly":26,"mx":164,"my":28},{"lx":166,"ly":26,"mx":165,"my":26},{"lx":166,"ly":25,"mx":166,"my":26},{"lx":167,"ly":24,"mx":166,"my":25},{"lx":167,"ly":23,"mx":167,"my":24},{"lx":168,"ly":22,"mx":167,"my":23},{"lx":169,"ly":22,"mx":168,"my":22},{"lx":169,"ly":21,"mx":169,"my":22},{"lx":170,"ly":20,"mx":169,"my":21},{"lx":170,"ly":19,"mx":170,"my":20},{"lx":171,"ly":18,"mx":170,"my":19},{"lx":172,"ly":18,"mx":171,"my":18},{"lx":173,"ly":17,"mx":172,"my":18},{"lx":173,"ly":16,"mx":173,"my":17},{"lx":174,"ly":15,"mx":173,"my":16},{"lx":174,"ly":14,"mx":174,"my":15},{"lx":174,"ly":13,"mx":174,"my":14},{"lx":175,"ly":12,"mx":174,"my":13},{"lx":176,"ly":11,"mx":175,"my":12},{"lx":177,"ly":11,"mx":176,"my":11}]';

        sigPad.signaturePad().regenerate(val);

        if (val == defaultSig) {
            sigPad.find(".clearButton").hide("fast").attr("aria-hidden", "true");
            sigPad.find(".oversurff").removeClass("displayNone");
            sigPad.find("input").prop("checked", true);
        }
        accSetImageData(sigPadID);
    }
}

function accSignaturePadClearCanvas(sigPadID) { 
    $(".sigPad" + sigPadID).signaturePad().clearCanvas();
    accSetImageData(sigPadID);
}

function accSignaturePadRegenerate(sigPadID) {
    var sigPad = $(".sigPad" + sigPadID);
    var defaultSig = '[{"lx":119,"ly":46,"mx":119,"my":45},{"lx":121,"ly":45,"mx":119,"my":46},{"lx":122,"ly":45,"mx":121,"my":45},{"lx":123,"ly":46,"mx":122,"my":45},{"lx":124,"ly":47,"mx":123,"my":46},{"lx":125,"ly":49,"mx":124,"my":47},{"lx":126,"ly":50,"mx":125,"my":49},{"lx":127,"ly":51,"mx":126,"my":50},{"lx":128,"ly":52,"mx":127,"my":51},{"lx":128,"ly":54,"mx":128,"my":52},{"lx":130,"ly":56,"mx":128,"my":54},{"lx":130,"ly":57,"mx":130,"my":56},{"lx":131,"ly":58,"mx":130,"my":57},{"lx":132,"ly":59,"mx":131,"my":58},{"lx":133,"ly":60,"mx":132,"my":59},{"lx":134,"ly":61,"mx":133,"my":60},{"lx":134,"ly":62,"mx":134,"my":61},{"lx":134,"ly":63,"mx":134,"my":62},{"lx":134,"ly":64,"mx":134,"my":63},{"lx":135,"ly":65,"mx":134,"my":64},{"lx":136,"ly":66,"mx":135,"my":65},{"lx":137,"ly":66,"mx":136,"my":66},{"lx":138,"ly":66,"mx":137,"my":66},{"lx":138,"ly":64,"mx":138,"my":66},{"lx":139,"ly":64,"mx":138,"my":64},{"lx":140,"ly":62,"mx":139,"my":64},{"lx":141,"ly":60,"mx":140,"my":62},{"lx":143,"ly":58,"mx":141,"my":60},{"lx":144,"ly":56,"mx":143,"my":58},{"lx":144,"ly":54,"mx":144,"my":56},{"lx":146,"ly":52,"mx":144,"my":54},{"lx":147,"ly":50,"mx":146,"my":52},{"lx":148,"ly":48,"mx":147,"my":50},{"lx":150,"ly":46,"mx":148,"my":48},{"lx":152,"ly":44,"mx":150,"my":46},{"lx":152,"ly":43,"mx":152,"my":44},{"lx":154,"ly":42,"mx":152,"my":43},{"lx":156,"ly":40,"mx":154,"my":42},{"lx":156,"ly":39,"mx":156,"my":40},{"lx":157,"ly":38,"mx":156,"my":39},{"lx":157,"ly":37,"mx":157,"my":38},{"lx":157,"ly":36,"mx":157,"my":37},{"lx":158,"ly":36,"mx":157,"my":36},{"lx":159,"ly":34,"mx":158,"my":36},{"lx":160,"ly":33,"mx":159,"my":34},{"lx":161,"ly":32,"mx":160,"my":33},{"lx":161,"ly":31,"mx":161,"my":32},{"lx":162,"ly":31,"mx":161,"my":31},{"lx":163,"ly":29,"mx":162,"my":31},{"lx":164,"ly":28,"mx":163,"my":29},{"lx":165,"ly":26,"mx":164,"my":28},{"lx":166,"ly":26,"mx":165,"my":26},{"lx":166,"ly":25,"mx":166,"my":26},{"lx":167,"ly":24,"mx":166,"my":25},{"lx":167,"ly":23,"mx":167,"my":24},{"lx":168,"ly":22,"mx":167,"my":23},{"lx":169,"ly":22,"mx":168,"my":22},{"lx":169,"ly":21,"mx":169,"my":22},{"lx":170,"ly":20,"mx":169,"my":21},{"lx":170,"ly":19,"mx":170,"my":20},{"lx":171,"ly":18,"mx":170,"my":19},{"lx":172,"ly":18,"mx":171,"my":18},{"lx":173,"ly":17,"mx":172,"my":18},{"lx":173,"ly":16,"mx":173,"my":17},{"lx":174,"ly":15,"mx":173,"my":16},{"lx":174,"ly":14,"mx":174,"my":15},{"lx":174,"ly":13,"mx":174,"my":14},{"lx":175,"ly":12,"mx":174,"my":13},{"lx":176,"ly":11,"mx":175,"my":12},{"lx":177,"ly":11,"mx":176,"my":11}]';

    if (sigPad.find("input").prop("checked") == false) {
        sigPad.find(".clearButton").show("fast").attr("aria-hidden", "false");
        accSignaturePadClearCanvas(sigPadID);
        sigPad.find(".oversurff").addClass("displayNone");
    }
    else {
        sigPad.find(".clearButton").hide("fast").attr("aria-hidden", "true");
        sigPad.signaturePad().regenerate(defaultSig);
        sigPad.find(".oversurff").removeClass("displayNone");
        accSetImageData(sigPadID);
    }
}

function accSetImageData(sigPadID) {
    var sigPad = $(".sigPad" + sigPadID);
    sigPad.parent().find(".output").val("");
    sigPad.parent().find(".input").val("");

    if (sigPad.signaturePad().getSignatureString().length > 2) {
        sigPad.parent().find(".output").val(sigPad.signaturePad().getSignatureImage());
        sigPad.parent().find(".input").val(sigPad.signaturePad().getSignatureString());
    }
}

function setTheErr(input, errPlace) {
    var t = errPlace.text();
    if (t.substr(-1) != ".") errPlace.text() + ".";

    accHtmlDialog.push(input.attr("title") + ": " + t);
    if (accFirstFocus == null) accFirstFocus = input;
    setUnValidControl(input);    
}

function myGetDirection(thisObj, flipp) {
    var direction = thisObj.attr("valuedirection");

    if (!flipp) return direction;
    return direction == "rtl" ? "ltr" : "rtl";
}

function setAccEvents(envControl, control) {
    setAccEventsNoDir(envControl, control);

    $(envControl + " " + control).each(function () {
        if (control != "select") {
            if ($(this).attr("dir") == "ltr" || $(this).parent().attr("dir") == "ltr" || envControl == ".signatureControl") {
                $(this).focus(function () { mySwitchDirection($(this)) }).blur(function () { myClearDirection($(this)) }).attr("valuedirection", "ltr").removeAttr("dir");
                if ($(this).val() != "") $(this).css("direction", "ltr");
            }
            if ($(this).parent().attr("dir") == "ltr") $(this).parent().removeAttr("dir");
        }
    });
}

function decodeHTMLEntities(text) {
    var entities = [['amp', '&'], ['apos', '\''], ['#x27', '\''], ['#x2F', '/'], ['#39', '\''], ['#47', '/'], ['lt', '<'], ['gt', '>'], ['nbsp', ' '], ['quot', '"']];

    for (var i = 0, max = entities.length; i < max; ++i)
        text = text.replace(new RegExp('&' + entities[i][0] + ';', 'g'), entities[i][1]);

    return text;
}

function setEditValues(envControl) {
    try {
        if (isPostBack == false) {
            $(envControl + " *[fieldEditData][fieldEditData != '']").each(function () {
                var data = $(this).attr("fieldEditData");

                $(this).find("input[type='checkbox']").each(function () {
                    if (data == "כן" || data == "yes" || data == "1") $(this)[0].checked = true;
                    else {
                        var dataArray = data.split(",");

                        for (var i = 0; i < dataArray.length; i++) {
                            if ($.trim(decodeHTMLEntities(dataArray[i])) == decodeHTMLEntities($(this).next().text())) $(this)[0].checked = true;
                        }
                    }
                });

                $(this).find("input[type='radio']").each(function () {
                    if (decodeHTMLEntities(data) == decodeHTMLEntities($(this).next().text())) $(this)[0].checked = true;
                });

                $(this).find("select").val(data);
                $(this).find("textarea").val(data);
                $(this).find("input").not("[type='checkbox'],[type='radio'],[type='file']").val(data);
            });
        }

        $(envControl + " *[fieldEditData][fieldEditData != '']").each(function () {
            var data = $(this).attr("fieldEditData");

            $(this).find("input[type='file']").each(function () {
                data = $("<span class='uFile'>" + decodeHTMLEntities(data) + "</span>");
                data.find("img").css({ "width": "50px", "height": "50px" });
                data.find("img").attr("src", _spPageContextInfo.webAbsoluteUrl + "/_layouts/GetPrivateAreaFile.aspx?file=" + _spPageContextInfo.webAbsoluteUrl + data.find("img").attr("src"));
                $(this).after(data);
            });
        });
    }
    catch (err) { }

    $(envControl + " *[fieldEditData][fieldEditData != '']").each(function () { $(this).removeAttr("fieldEditData"); });
}

function setValidationAndAcc(envControl) {
    if ($(envControl).length <= 0) return;

    $(envControl + " input[type='submit']").click(function () { return submitMustEmptyFields(envControl); });
    $(envControl + " [fieldType='RatingScaleField'] input").each(function () { $(this).attr("aria-label", $(this).attr("title")) });    

    setEditValues(envControl);
    setAccEvents(envControl, "input");
    setAccEvents(envControl, "select");
    setAccEvents(envControl, "textarea");

    $(envControl + " *[fieldType='NumberField'] input").prop("type", "number").attr("step", "any");    
    $(envControl + " *[fieldType='RegularExpression'][pattren='^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$'] input").prop("type", "email");   

    $(envControl + " .ms-formvalidation:not(:empty)").each(function () {
        if ($(this).text() != "*") {
            var fieldType = $(this).parent().parent().attr("fieldType");

            if (fieldType == "RadioButtonChoiceField" || fieldType == "CheckBoxChoiceField") setTheErrChoise($(this));
            else if (fieldType == "RatingScaleField") setTheErrRatingScaleField($(this));
            else {
                setErr($(this), "input");
                setErr($(this), "select");
                setErr($(this), "textarea");
            }
        }
    });
}

function setErr(selector, control) {    
    if (!isUndefined(selector.parent().find(control).attr("title"))) setTheErr(selector.parent().find(control), selector);
    else if (!isUndefined(selector.parent().parent().find(control).attr("title")) && !selector.parent().parent().hasClass("signatureControl")) setTheErr(selector.parent().parent().find(control), selector);    
}

function setTheErrRatingScaleField(errPlace) {    
    var fieldText = errPlace.text();
    var fieldLabel = errPlace.parent().parent().attr("fieldLabel");    

    errPlace.parent().parent().parent().find(".ms-gridT1").each(function () {
        var input = $(this).find("input:first()");
        accHtmlDialog.push(fieldLabel + ": " + fieldText + ".");
        if (accFirstFocus == null) accFirstFocus = input;
    });            
}

function setTheErrChoise(errPlace) {   
    var input = errPlace.parent().parent().parent().find("input:first()");
    accHtmlDialog.push(errPlace.parent().parent().attr("fieldLabel") + ": " + errPlace.text() + ".");
    if (accFirstFocus == null) accFirstFocus = input;
}

function alertErr(errs, focus) {
    if (errs.length <= 0) return true;
    alert(errs.join("\n"));
    if (focus != null) focus[0].focus();
    return false;
}

function submitMustEmptyFields(envControl) {
    var innerFirstFocus = null;
    var innerHtmlDialog = new Array();     

    $(envControl + " *[aria-required='true']").not(".input,.output").each(function () {
        var input = $(this);

        if (input.val() == "") {
            if (innerFirstFocus == null) innerFirstFocus = input;
            setUnValidControl(input);
            innerHtmlDialog.push(input.attr("title") + ": " + accScriptTitle[2]);
        }
        else if (accGetAttributeValue(input.attr("extraValidationFunction")) != "") {
            try {
                if (!eval(input.attr("extraValidationFunction"))(input)) {
                    if (innerFirstFocus == null) innerFirstFocus = input;
                    setUnValidControl(input);
                    innerHtmlDialog.push(input.attr("title") + ": " + input.attr("extraValidationFunctionErrMessage"));
                }
            }
            catch (err) { }
        }
        else
            setValidControl(input);
    });       

    $(envControl + " *[fieldIsRequired='true'][fieldType='CheckBoxChoiceField']").each(function () {
        var input = $(this).find("input:first()");
        setValidChange2($(this));

        if (!accGetAnyChecked($(this))) {
            if (innerFirstFocus == null) innerFirstFocus = input;
            setUnValidControl2($(this));
            innerHtmlDialog.push($(this).attr("fieldLabel") + ": " + accScriptTitle[2]);
        }
    });

    $(envControl + " *[fieldIsRequired='true'][fieldType='RadioButtonChoiceField']").each(function () {
        var input = $(this).find("input:first()");
        setValidChange2($(this));

        if (!accGetAnyChecked($(this))) {
            if (innerFirstFocus == null) innerFirstFocus = input;
            setUnValidControl2($(this));
            innerHtmlDialog.push($(this).attr("fieldLabel") + ": " + accScriptTitle[2]);
        }
    });

    $(envControl + " *[fieldIsRequired='true'][fieldType='Signature']").each(function () {
        var input = $(this).find("input:first()");
        setValidChange2($(this));

        if ($(this).find(".input").val() == "") {
            if (innerFirstFocus == null) innerFirstFocus = input;
            setUnValidControl2($(this));
            innerHtmlDialog.push($(this).attr("fieldLabel") + ": " + accScriptTitle[2]);
        }
    });

    $(envControl + " *[fieldIsRequired='true'][fieldType='RatingScaleField']").each(function () {
        var fieldLabel = $(this).attr("fieldLabel");

        $(this).find(".ms-gridT1").each(function () { 
            var input = $(this).parent().find("input:first()");                           
            setValidChange2($(this)); 

            if (!accGetAnyChecked($(this).parent())) {                
                if (innerFirstFocus == null) innerFirstFocus = input;
                setUnValidControl2($(this));
                innerHtmlDialog.push(fieldLabel + " " + $(this).text() + ": " + accScriptTitle[2]);
            }            
        });      
    });    

    $(envControl + " input[type='file']").each(function () {
        var input = $(this);
        var maxSize = 26214400;
        var arrType = new Array();
        var arrSize = new Array();
        var files = input[0].files;
        var arrSizeMax = new Array();        
        var uploadTypes = new Array();
        var filesLength = files.length;
        var multiple = accGetAttributeValue(input.attr("multiple"));
        var limitFiles = parseInt(accGetAttributeValue(input.attr("limitFiles")));
        var uploadSize = parseInt(accGetAttributeValue(input.attr("UploadSize")));         

        if (accGetAttributeValue(input.attr("aria-invalid")) != "true") setValidChange(input);        
        
        if (isNaN(limitFiles)) limitFiles = 0;
        if (isNaN(uploadSize)) uploadSize = 0;
        if (accGetAttributeValue(input.attr("UploadType")) != "") uploadTypes = accGetAttributeValue(input.attr("UploadType")).toLowerCase().split(";");
        
        for (var i = 0; i < filesLength; i++) {
            var name = files[i].name;
            var size = parseInt(files[i].size);

            if (size > maxSize) arrSizeMax.push(name);
            if (!isImageFile(name) && uploadSize > 0 && $.inArray(name, arrSize) == -1 && size > uploadSize) arrSize.push(name);
            if (uploadTypes.length > 0 && $.inArray(name.toLowerCase().match(/\.([^\.]+)$/)[1], uploadTypes) == -1) arrType.push(name);
        }

        if (multiple != "" && limitFiles > 0) {
            if (filesLength > limitFiles) {
                if (innerFirstFocus == null) innerFirstFocus = input;
                setUnValidControl(input);
                innerHtmlDialog.push(input.attr("title") + ": " + accScriptTitle[3] + limitFiles);
                return;
            }

            if (accGetAttributeValue(input.attr("aria-required")) == "true" && filesLength > 0 && filesLength < limitFiles) {
                if (innerFirstFocus == null) innerFirstFocus = input;
                setUnValidControl(input);
                innerHtmlDialog.push(input.attr("title") + ": חובה לבחור " + limitFiles + " קבצים");
                return;
            }
        } 

        if (arrType.length > 0) {
            var err = "";

            if (arrType.length == 1) err = "הקובץ " + arrType.join() + " אינו מותר, סוגי הקבצים המותרים הם: ";
            if (arrType.length > 1) err = "הקבצים:\n" + arrType.join("\n") + "\n אינם מותרים, סוגי הקבצים המותרים הם: ";

            if (innerFirstFocus == null) innerFirstFocus = input;
            setUnValidControl(input);
            innerHtmlDialog.push(input.attr("title") + ": " + err + uploadTypes.join(","));
            return;
        }                       

        if (arrSize.length > 0) {
            var err = "";

            if (arrSize.length == 1) err = "הקובץ " + arrSize.join() + " עבר את הגודל המרבי, הגודל המרבי הוא: ";
            if (arrSize.length > 1) err = "הקבצים:\n" + arrSize.join("\n") + "\n עברו את הגודל המרבי, הגודל המרבי הוא: ";

            if (innerFirstFocus == null) innerFirstFocus = input;
            setUnValidControl(input);
            innerHtmlDialog.push(input.attr("title") + ": " + err + getSizeText(uploadSize));
            return;
        }

        if (arrSizeMax.length > 0) {
            var err = "";

            if (arrSizeMax.length == 1) err = "הקובץ " + arrSizeMax.join() + " עבר את הגודל המרבי, הגודל המרבי הוא: ";
            if (arrSizeMax.length > 1) err = "הקבצים:\n" + arrSizeMax.join("\n") + "\n עברו את הגודל המרבי, הגודל המרבי הוא: ";

            if (innerFirstFocus == null) innerFirstFocus = input;
            setUnValidControl(input);
            innerHtmlDialog.push(input.attr("title") + ": " + err + getSizeText(maxSize));
            return;
        }
    });

    $(envControl + " *[fieldType='RegularExpression']").each(function () {
        try {
            var input = $(this).find("input");
            var pattren = accGetAttributeValue($(this).attr("pattren"));
            var pattrenmessage = accGetAttributeValue($(this).attr("pattrenmessage"));

            if (accGetAttributeValue(input.attr("aria-invalid")) != "true") setValidChange(input);

            if (pattren != "" && pattrenmessage != "" && input.val() != "" && !new RegExp(pattren).test(input.val())) {
                if (innerFirstFocus == null) innerFirstFocus = input;
                setUnValidControl(input);
                innerHtmlDialog.push(input.attr("title") + ": " + pattrenmessage);
            }
        }
        catch (err) { }
    });   
    
    if (alertErr(innerHtmlDialog, innerFirstFocus)) {
        $(envControl + " .buttonsTable").append("<div aria-label=\"" + accScriptTitle[1] + "\" role=\"progressbar\" aria-hidden=\"false\" aria-valuenow=\"20\" aria-valuemin=\"0\" aria-valuetext=\"" + accScriptTitle[1] + "\" aria-valuemax=\"100\" role='alert' class=\"sendFormLoad\">" + accScriptTitle[1] + "</div>");
        $(envControl + " input[type='submit']").hide().attr("aria-hidden", "true");
        $(envControl + " input[type='button']").hide().attr("aria-hidden", "true");
        return true;
    }

    return false;
}
function submitMustEmptyFieldsStages(envControl) {
    var innerFirstFocus = null;
    var innerHtmlDialog = new Array();

    $(envControl + " *[aria-required='true']").not(".input,.output").each(function () {
        var input = $(this);

        if (input.val() == "") {
            if (innerFirstFocus == null) innerFirstFocus = input;
            setUnValidControl(input);
            innerHtmlDialog.push(input.attr("title") + ": " + accScriptTitle[2]);
        }
        else if (accGetAttributeValue(input.attr("extraValidationFunction")) != "") {
            try {
                if (!eval(input.attr("extraValidationFunction"))(input)) {
                    if (innerFirstFocus == null) innerFirstFocus = input;
                    setUnValidControl(input);
                    innerHtmlDialog.push(input.attr("title") + ": " + input.attr("extraValidationFunctionErrMessage"));
                }
            }
            catch (err) { }
        }
        else
            setValidControl(input);
    });   

    $(envControl + " *[fieldIsRequired='true'][fieldType='RadioButtonChoiceField']").each(function () {
        var input = $(this).find("input:first()");

        if (!accGetAnyChecked($(this))) {
            if (innerFirstFocus == null) innerFirstFocus = input;
            setUnValidControl2($(this));
            innerHtmlDialog.push($(this).attr("fieldLabel") + ": " + accScriptTitle[2]);
        }
    });

    $(envControl + " *[fieldIsRequired='true'][fieldType='CheckBoxChoiceField']").each(function () {
        var input = $(this).find("input:first()");

        if (!accGetAnyChecked($(this))) {
            if (innerFirstFocus == null) innerFirstFocus = input;
            setUnValidControl2($(this));
            innerHtmlDialog.push($(this).attr("fieldLabel") + ": " + accScriptTitle[2]);
        }
    });

    $(envControl + " *[fieldIsRequired='true'][fieldType='Signature']").each(function () {
        var input = $(this).find("input:first()");
        setValidChange2($(this));

        if ($(this).find(".input").val() == "") {
            if (innerFirstFocus == null) innerFirstFocus = input;
            setUnValidControl2($(this));
            innerHtmlDialog.push($(this).attr("fieldLabel") + ": " + accScriptTitle[2]);
        }
    });

    $(envControl + " *[fieldIsRequired='true'][fieldType='RatingScaleField']").each(function () {
        var fieldLabel = $(this).attr("fieldLabel");

        $(this).find(".ms-gridT1").each(function () {
            var input = $(this).parent().find("input:first()");
            setValidChange2($(this));

            if (!accGetAnyChecked($(this).parent())) {
                if (innerFirstFocus == null) innerFirstFocus = input;
                setUnValidControl2($(this));
                innerHtmlDialog.push(fieldLabel + " " + $(this).text() + ": " + accScriptTitle[2]);
            }
        });
    });

    $(envControl + " input[type='file']").each(function () {
        var input = $(this);
        var maxSize = 26214400;
        var arrType = new Array();
        var arrSize = new Array();
        var files = input[0].files;
        var arrSizeMax = new Array();
        var uploadTypes = new Array();
        var filesLength = files.length;
        var multiple = accGetAttributeValue(input.attr("multiple"));
        var limitFiles = parseInt(accGetAttributeValue(input.attr("limitFiles")));
        var uploadSize = parseInt(accGetAttributeValue(input.attr("UploadSize")));

        if (accGetAttributeValue(input.attr("aria-invalid")) != "true") setValidChange(input);

        if (isNaN(limitFiles)) limitFiles = 0;
        if (isNaN(uploadSize)) uploadSize = 0;
        if (accGetAttributeValue(input.attr("UploadType")) != "") uploadTypes = accGetAttributeValue(input.attr("UploadType")).toLowerCase().split(";");

        for (var i = 0; i < filesLength; i++) {
            var name = files[i].name;
            var size = parseInt(files[i].size);

            if (size > maxSize) arrSizeMax.push(name);
            if (!isImageFile(name) && uploadSize > 0 && $.inArray(name, arrSize) == -1 && size > uploadSize) arrSize.push(name);
            if (uploadTypes.length > 0 && $.inArray(name.toLowerCase().match(/\.([^\.]+)$/)[1], uploadTypes) == -1) arrType.push(name);
        }

        if (multiple != "" && limitFiles > 0) {
            if (filesLength > limitFiles) {
                if (innerFirstFocus == null) innerFirstFocus = input;
                setUnValidControl(input);
                innerHtmlDialog.push(input.attr("title") + ": " + accScriptTitle[3] + limitFiles);
                return;
            }

            if (accGetAttributeValue(input.attr("aria-required")) == "true" && filesLength > 0 && filesLength < limitFiles) {
                if (innerFirstFocus == null) innerFirstFocus = input;
                setUnValidControl(input);
                innerHtmlDialog.push(input.attr("title") + ": חובה לבחור " + limitFiles + " קבצים");
                return;
            }
        }

        if (arrType.length > 0) {
            var err = "";

            if (arrType.length == 1) err = "הקובץ " + arrType.join() + " אינו מותר, סוגי הקבצים המותרים הם: ";
            if (arrType.length > 1) err = "הקבצים:\n" + arrType.join("\n") + "\n אינם מותרים, סוגי הקבצים המותרים הם: ";

            if (innerFirstFocus == null) innerFirstFocus = input;
            setUnValidControl(input);
            innerHtmlDialog.push(input.attr("title") + ": " + err + uploadTypes.join(","));
            return;
        }

        if (arrSize.length > 0) {
            var err = "";

            if (arrSize.length == 1) err = "הקובץ " + arrSize.join() + " עבר את הגודל המרבי, הגודל המרבי הוא: ";
            if (arrSize.length > 1) err = "הקבצים:\n" + arrSize.join("\n") + "\n עברו את הגודל המרבי, הגודל המרבי הוא: ";

            if (innerFirstFocus == null) innerFirstFocus = input;
            setUnValidControl(input);
            innerHtmlDialog.push(input.attr("title") + ": " + err + getSizeText(uploadSize));
            return;
        }

        if (arrSizeMax.length > 0) {
            var err = "";

            if (arrSizeMax.length == 1) err = "הקובץ " + arrSizeMax.join() + " עבר את הגודל המרבי, הגודל המרבי הוא: ";
            if (arrSizeMax.length > 1) err = "הקבצים:\n" + arrSizeMax.join("\n") + "\n עברו את הגודל המרבי, הגודל המרבי הוא: ";

            if (innerFirstFocus == null) innerFirstFocus = input;
            setUnValidControl(input);
            innerHtmlDialog.push(input.attr("title") + ": " + err + getSizeText(maxSize));
            return;
        }
    });

    $(envControl + " *[fieldType='RegularExpression']").each(function () {
        try {
            var input = $(this).find("input");
            var pattren = accGetAttributeValue($(this).attr("pattren"));
            var pattrenmessage = accGetAttributeValue($(this).attr("pattrenmessage"));

            if (accGetAttributeValue(input.attr("aria-invalid")) != "true") setValidChange(input);

            if (pattren != "" && pattrenmessage != "" && input.val() != "" && !new RegExp(pattren).test(input.val())) {
                if (innerFirstFocus == null) innerFirstFocus = input;
                setUnValidControl(input);
                innerHtmlDialog.push(input.attr("title") + ": " + pattrenmessage);
            }
        }
        catch (err) { }
    });

    return alertErr(innerHtmlDialog, innerFirstFocus);
}

function accInitStages(cssEnv) {
    setTimeout(function () {
        var labelArray = new Array();
        
        if (accLangID == "EN") labelArray = new Array("< Previous stage", "Next stage >");
        else if (accLangID == "AR") labelArray = new Array("< المرحلة السابقة", "المرحلة المقبلة >");
        else if (accLangID == "FR") labelArray = new Array("< Étape précédente", "Étape suivante >");
        else if (accLangID == "RU") labelArray = new Array("< Предыдущий этап", "Следующий этап >");

        if (labelArray.length > 0) {
            $(".stages .prevStage .prevStageBtn").attr("value", labelArray[0]).attr("title", labelArray[0]);
            $(".stages .nextStage .nextStageBtn").attr("value", labelArray[1]).attr("title", labelArray[1]);
        }

        if ($("h1").text() != '') $(".stagsCaption").html($("h1").text());

        var flag = false;
        $(".stages .stage").each(function (index) {
            if (!flag && $(this).find("*[aria-invalid='true']").length > 0) {
                var active = $('.stages .stage.active');
                var next = $(this);

                if (!next.next().hasClass("stage")) {
                    $(".stages .nextStage .nextStageBtn").attr("aria-hidden", "true").hide("fast");
                    $(".stages .nextStage .nextUpdateButton").attr("aria-hidden", "false").show("fast");
                }

                $(".stages .prog.active").removeClass("active");
                $(".stages .prog[progID='" + next.attr("stageID") + "']").addClass("active");
                
                active.attr("aria-hidden", "true").hide("fast").removeClass("active");
                next.attr("aria-hidden", "false").show("fast").addClass("active");

                if (!next.prev().hasClass("stage"))
                    $(".stages .prevStage .prevStageBtn").attr("aria-hidden", "true").hide("fast");
                else
                    $(".stages .prevStage .prevStageBtn").attr("aria-hidden", "false").show("fast");

                $(this).find("*[aria-invalid='true']")[0].focus();
                flag = true;
            }
        });

        setStageStatus();
    }, 500)
}

function accNextStage() {
    if (!submitMustEmptyFieldsStages(".stages .stage.active")) return;

    var active = $('.stages .stage.active');
    if (!active.next().next().hasClass("stage")) {
        $(".stages .nextStage .nextStageBtn").attr("aria-hidden", "true").hide("fast");
        $(".stages .nextStage .nextUpdateButton").attr("aria-hidden", "false").show("fast");
    }

    var next = active.next();
    $(".stages .prog.active").removeClass("active");
    $(".stages .prog[progID='" + next.attr("stageID") + "']").addClass("active");
    active.attr("aria-hidden", "true").hide("fast").removeClass("active");
    next.attr("aria-hidden", "false").show("fast").addClass("active");
    //next.find("select,input,textarea")[0].focus();
    $(".stages .prevStage .prevStageBtn").attr("aria-hidden", "false").show("fast");

    setStageStatus();
    accDoAnchor('#stagsArea');
}

function accPrevStage() {
    var active = $('.stages .stage.active');
    if (!active.prev().prev().hasClass("stage")) $(".stages .prevStage .prevStageBtn").attr("aria-hidden", "true").hide("fast");

    var next = active.prev();
    $(".stages .prog.active").removeClass("active");
    $(".stages .prog[progID='" + next.attr("stageID") + "']").addClass("active");
    active.attr("aria-hidden", "true").hide("fast").removeClass("active");
    next.attr("aria-hidden", "false").show("fast").addClass("active");
    //next.find("select,input,textarea")[0].focus();
    $(".stages .nextStage .nextStageBtn").attr("aria-hidden", "false").show("fast");
    $(".stages .nextStage .nextUpdateButton").attr("aria-hidden", "true").hide("fast");
    
    setStageStatus();
    accDoAnchor('#stagsArea');
}

function setStageStatus() {
    var labelArray = new Array("שלב נוכחי", "שלב בוצע");

    if (accLangID == "EN") labelArray = new Array("Current Stage", "Step Done");
    else if (accLangID == "AR") labelArray = new Array("المرحلة الحالية", "الخطوة فعلت");
    else if (accLangID == "FR") labelArray = new Array("Étape actuelle", "Étape terminée");
    else if (accLangID == "RU") labelArray = new Array("Текущая стадия", "Шаг сделан");

    var foundCurrent = false;
    $(".stageProgress .prog").each(function (index) {
        $(this).find(".stageStatus").html("");

        if ($(this).hasClass("active")) {
            foundCurrent = true;
            $(this).find(".stageStatus").html(labelArray[0]);
        }
        else if (!foundCurrent)
            $(this).find(".stageStatus").html(labelArray[1]);
    });
}

function setValidChange(input) {
    if (input == null || input.length <= 0) return;
    setValidControl(input);
    input.unbind("change");
    input.change(function () { setValidControl(input) });
}

function setUnValidControl2(input) {
    if (input == null || input.length <= 0) return;
    input.css("border-style", "solid");
    setUnValidControl(input);
}

function setValidChange2(input) {
    if (input == null || input.length <= 0) return;
    input.css("border-style", "");
    setValidControl(input);
    input.unbind("change");
    input.change(function () {
        input.css("border-style", "");
        setValidControl(input);
    });
}

function getSizeText(size) {
    if (size < 1048576) return Math.round(size / 1024) + " kb";
    if (size >= 1048576) return Math.round(size / 1048576) + " mb";
}

function isImageFile(fileName) {
    var imagesExtensionArray = new Array("gif", "png", "jpeg", "jpg");
    var fileExtensionArray = fileName.split(".");
    var fileExtension = fileExtensionArray[fileExtensionArray.length - 1].toLowerCase();
    if ($.inArray(fileExtension, imagesExtensionArray) != -1) return true;
    return false;
}

function accGetAnyChecked(inputsPlace) {
    var checked = false;
    inputsPlace.find("input").each(function () { checked = checked || $(this)[0].checked; });
    return checked;
}

function accIsTZ(input, addZero, matchZero) {
    var R_VALID = 1;
    var R_NOT_VALID = -2;
    var R_ELEGAL_INPUT = -1;
    var IDnum = input.val();

    if (matchZero) {
        if ((IDnum.length > 9) || (IDnum.length < 2)) return R_ELEGAL_INPUT;
    }
    else {
        if ((IDnum.length > 9) || (IDnum.length < 9)) return R_ELEGAL_INPUT;
    }

    if (isNaN(IDnum)) return R_ELEGAL_INPUT;

    if (IDnum.length < 9) {
        while (IDnum.length < 9) IDnum = "0" + IDnum;
    }

    var mone = 0, incNum;
    for (var i = 0; i < 9; i++) {
        incNum = Number(IDnum.charAt(i));
        incNum *= (i % 2) + 1;

        if (incNum > 9) incNum -= 9;
        mone += incNum;
    }

    if (mone % 10 == 0) {
        if (addZero) input.val("" + IDnum);
        return R_VALID;
    }

    return R_NOT_VALID;
}

function accFixHeight() {
    var acc = $("#accData");
    
    if (acc.css("display") == "none") return;
    acc.css({ "overflow-y": "visible", "overflow-x": "visible", "height": "auto" });

    if ($("body").height() < acc.height() + 50) acc.css({ "overflow-y": "auto", "overflow-x": "hidden", "height": $("body").height() - 50 + "px" });
}

function accOpenAcc(linkID, accID) {
    var acc = $("#" + accID);

    if (!accAccState) {
        acc.show("slide", { direction: "right" }, function () { accFixHeight() }).attr("aria-hidden", "false");
        $("#" + linkID).css("top", "0px");
        $(window).resize(function () { accFixHeight() });
    }
    else {
        acc.hide("slide", { direction: "right" }).attr("aria-hidden", "true");
        $("#" + linkID).css("top", "-9999px");
    }

    accAccState = !accAccState;
}

function accFlashMove() {
    var flashMoveLink = $("#flashMove");

    if (accFlickState) {
        accDeleteCookie("flashMove");
        $(".ad-slideshow-start").trigger("click");
        $("#accLinkNew").attr("aria-labelledby", "accLabelTo");

        flashMoveLink.removeClass("selected");
        setLabelMessage(flashMoveLink, 0);
        flashMoveLink.removeClass(flashMoveLink.attr("activeClass")).addClass(flashMoveLink.attr("defaultClass"));                

        try { accStartMarquees(); } catch (err) { }
        try { accStartFlickers(); } catch (err) { }
        try { extraStartFlashMove(); } catch (err) { }
    }
    else {
        setLabelMessage($(".accLinkNew"), 1);
        accSetCookie("flashMove", "1", 1);
        $(".ad-slideshow-stop").trigger("click");
        $("#accLinkNew").removeAttr("aria-labelledby");
        try { $($(".easy-accordion dt[class='active'")[0]).click(); } catch (err) { };

        flashMoveLink.addClass("selected");
        setLabelMessage(flashMoveLink, 1);        
        flashMoveLink.removeClass(flashMoveLink.attr("defaultClass")).addClass(flashMoveLink.attr("activeClass"));

        try { accStopMarquees(); } catch (err) { }
        try { accStopFlickers(); } catch (err) { }
        try { extraStopFlashMove(); } catch (err) { }
    }

    accFlickState = !accFlickState;
    accSetCaption();
}

function accChangeFont(number) {    
    accChangeFontToDefault();
    $("#changeFont2").parent().attr("aria-checked", "false");

    if (number == 0) {
        loadChangeFontSize(7);
        extraExpCollGroupChangeFont(7);
        accSetCookie("changeFont", "0", 1);
        $("#changeFont0").addClass("selected").parent().attr("aria-checked", "true");
    }
    else if (number == 1) {
        loadChangeFontSize(5);
        extraExpCollGroupChangeFont(5);
        accSetCookie("changeFont", "1", 1);
        $("#changeFont1").addClass("selected").parent().attr("aria-checked", "true");
    }

    accSetCaption();
    try { extraChangeFont(); } catch (err) { }
}

function accChangeFontToDefault() {
    $("#changeFont0").removeClass("selected").parent().attr("aria-checked", "false");
    $("#changeFont1").removeClass("selected").parent().attr("aria-checked", "false");
    $("#changeFont2").parent().attr("aria-checked", "true");

    $("*[CFS='true']").each(function () {
        var currentElement = $(this);

        accChangeCssAttrubute(currentElement, "CFS-font", "fontSize");
        accChangeCssAttrubute(currentElement, "CFS-line", "lineHeight");
        currentElement.removeAttr("CFS");
    });

    $("*[CFSWP='true']").each(function () {
        var currentElement = $(this);

        accChangeCssAttrubute(currentElement, "CFSWP-word", "wordBreak");
        currentElement.removeAttr("CFSWP");
    });

    try { extraChangeFontDefault(); } catch (err) { }
    accDeleteCookie("changeFont");
    accSetCaption();
}

function accChangeBackground(number) {
    accChangeColorsToDefault();
    $("#changeBackground2").parent().attr("aria-checked", "false");

    if (number == 0) {
        accSetCookie("changeBackground", "0", 1);
        loadChangeBackgroundColor('#c2d3fc', '#000000');
        extraExpCollGroupground('#c2d3fc', '#000000');        
        $("#changeBackground0").addClass("selected").parent().attr("aria-checked", "true");
    }
    else {
        accSetCookie("changeBackground", "1", 1);
        loadChangeBackgroundColor('#000000', '#ffff00');
        extraExpCollGroupground('#000000', '#ffff00');        
        $("#changeBackground1").addClass("selected").parent().attr("aria-checked", "true");
    }

    try { extraChangeBackground(); } catch (err) { }
    accSetCaption();
}

function accChangeColorsToDefault() {
    $("#changeBackground0").removeClass("selected").parent().attr("aria-checked", "false");
    $("#changeBackground1").removeClass("selected").parent().attr("aria-checked", "false");
    $("#changeBackground2").parent().attr("aria-checked", "true");

    $("*[CBC='true']").each(function () {
        var currentElement = $(this);
        
        accChangeCssAttrubute(currentElement, "CBC-color", "color");
        accChangeCssAttrubute(currentElement, "CBC-border", "borderColor");
        accChangeCssAttrubute(currentElement, "CBC-background", "backgroundColor");
        currentElement.removeAttr("CBC");
    });

    try { extraChangeBackgroundDefault(); } catch (err) { }
    accDeleteCookie("changeBackground");
    accSetCaption();
}

function accChangeFontSizeAfter(changeFont, el) {    
    if (changeFont == "0") changeFontSize(el, 7);
    else if (changeFont == "1") changeFontSize(el, 5);
}

function accChangeBackgroundAfter(changeBackground, el) {
    if (changeBackground == "0") changeBackgroundColor(el, '#c2d3fc', '#000000');
    else if (changeBackground == "1") changeBackgroundColor(el, '#000000', '#ffff00');
}

function extraExpCollGroupground(backgroundColor, fontColor) {
    $("a[onclick^='javascript:ExpCollGroup(']").each(function () {
        setB2($(this), backgroundColor, fontColor);
        $(this).click(function () { setB($(this), backgroundColor, fontColor) });
    });
}

function extraExpCollGroupChangeFont(fontSizeAmount) {
    $("a[onclick^='javascript:ExpCollGroup(']").each(function () {
        setF2($(this), fontSizeAmount);
        $(this).click(function () { setF($(this), fontSizeAmount) });
    });
}

function setB2(a, backgroundColor, fontColor) {
    valB = valB + 500;
    if (valB == 500) valB = 1000;
    setTimeout(function () { setBActive(a, backgroundColor, fontColor) }, valB);
}

function setF2(a, fontSizeAmount) {
    val = val + 500;
    if (val == 500) val = 1000;
    setTimeout(function () { setFActive(a, fontSizeAmount) }, val);
}

function setB(a, backgroundColor, fontColor) { setTimeout(function () { setBActive(a, backgroundColor, fontColor) }, 500); }
function setF(a, fontSizeAmount) { setTimeout(function () { setFActive(a, fontSizeAmount) }, 500); }

function setBActive(a, backgroundColor, fontColor) {
    var b = $("#tbod" + a.find("img").attr("id").replace("img_", "") + "_");

    if (b.length == 0) return;
    if (b.find("tr").length == 0) return;
    if (b.css("display") == "none") return;
    if (accGetArrayIndex2(doneArrB, b.attr("id")) != -1) return;

    doneArrB.push(b.attr("id"));  
    changeBackgroundColor(b[0], backgroundColor, fontColor);
}
function setFActive(a, fontSizeAmount) {
    var b = $("#tbod" + a.find("img").attr("id").replace("img_", "") + "_");

    if (b.length == 0) return;
    if (b.find("tr").length == 0) return;
    if (b.css("display") == "none") return;
    if (accGetArrayIndex2(doneArr, b.attr("id")) != -1) return;

    doneArr.push(b.attr("id"));
    changeFontSize(b[0], fontSizeAmount);
}

function accDoAnchor(anchor) {
    if (anchor == "#search" && $("#searchMob").length > 0 && $("#searchMob").css("display") != "none") anchor = "#searchMob";
    if (anchor == "#navigation" && $("#navigationMob").length > 0 && $("#navigationMob").css("display") != "none") anchor = "#navigationMob";
    
    accAccState = true;
    window.location.href = anchor;
    accOpenAcc('accLinkNew', 'accDataNew');
}

function accActivatelinkTurnOnAcc(flag) {
    var thisLink = $("#linkAccSP");

    if (flag == "1") {
        setLabelMessage($("#accLinkNew"), 1);
        accSetCookie("linkAcc", "1", 1);

        setLabelMessage(thisLink, 1);        
        thisLink.addClass("selected").attr("href", "javascript:accActivatelinkTurnOnAcc(0)").removeClass(thisLink.attr("defaultClass")).addClass(thisLink.attr("activeClass"));      
        $("#linkTurnOnAcc")[0].click();
    }
    else {
        $("#linkTurnOffAcc")[0].click();
        setLabelMessage(thisLink, 0);
        thisLink.removeClass("selected").attr("href", "javascript:accActivatelinkTurnOnAcc(1)").removeClass(thisLink.attr("activeClass")).addClass(thisLink.attr("defaultClass"));      
        accDeleteCookie("linkAcc");
    }

    thisLink[0].focus();
    accSetCaption();
}

function accUnderlineLinks(flag) {
    var thisLink = $("#underlineLinks");

    if (flag == 1) {
        setLabelMessage($("#accLinkNew"), 1);        
        accSetCookie("underlineLinks", "1", 1);

        setLabelMessage(thisLink, 1);        
        thisLink.addClass("selected").attr("href", "javascript:accUnderlineLinks(0)").removeClass(thisLink.attr("defaultClass")).addClass(thisLink.attr("activeClass"));

        $("#siteOnly a[ULL!='true'], #accDataNew a span, .mainLinkNew span, .keyboradLinkNew span, .accLinkNew span").each(function () {
            var currentElement = $(this);

            accResetCssAttribute(currentElement, "ULL-text", "textDecoration");
            accResetCssAttribute(currentElement.find("span"), "ULL-text", "textDecoration");
            currentElement.attr("ULL", "true").style("text-decoration", "underline", "important");
            currentElement.find("span").attr("ULL", "true").style("text-decoration", "underline", "important");
        });

        try { extraUnderlineLinks(); } catch (err) { }
    }
    else {
        setLabelMessage(thisLink, 0);
        thisLink.removeClass("selected").attr("href", "javascript:accUnderlineLinks(1)").removeClass(thisLink.attr("activeClass")).addClass(thisLink.attr("defaultClass"));

        $("a[ULL='true'], span[ULL='true']").each(function () {
            var currentElement = $(this);
            accChangeCssAttrubute(currentElement, "ULL-text", "textDecoration");
            currentElement.removeAttr("ULL")
        });

        accDeleteCookie("underlineLinks");
        try { extraUnderlineLinksDefault(); } catch (err) { }
    }

    accSetCaption();
}

function accImageHelper(flag) {
    var thisLink = $("#imageHelper");

    if (flag == 1) {
        accSetCookie("imageHelper", "1", 1);
        setLabelMessage(thisLink, 1);
        thisLink.addClass("selected").attr("href", "javascript:accImageHelper(0)").removeClass(thisLink.attr("defaultClass")).addClass(thisLink.attr("activeClass"));        

        $("#siteOnly img[alt!='']").each(function () {
            $(this).attr("IH", "true").mouseover(function () { showImgBox($(this)) }).focus(function () { showImgBox($(this)) }).mouseout(function () { hideImgBox($(this)) }).blur(function () { hideImgBox($(this)) });
        });

        try { extraImageHelper(); } catch (err) { }
    }
    else {        
        setLabelMessage(thisLink, 0);
        thisLink.removeClass("selected").attr("href", "javascript:accImageHelper(1)").removeClass(thisLink.attr("activeClass")).addClass(thisLink.attr("defaultClass"));
        
        $("#siteOnly img[IH='true']").removeAttr("IH");
        accDeleteCookie("imageHelper");
        try { extraImageHelperDefault(); } catch (err) { }
    }

    accSetCaption();
}

function showImgBox(thisIMg) {
    if (accGetAttributeValue(thisIMg.attr("IH")) == "") return;

    var box = $("<div class='boxImg' style='position:relative'><div class='boxImgInner displayNone' style='position:absolute;z-index:100;background-color:white;color:black;border:1px black solid;padding:10px;margin-top:3px;'></div></div>");

    thisIMg.after(box);

    var changeFont = accGetCookie("changeFont");
    var changeBackground = accGetCookie("changeBackground");
    if (changeFont != "" || changeBackground != "") {
        var el = box[0];
        accChangeFontSizeAfter(changeFont, el);
        accChangeBackgroundAfter(changeBackground, el);
    }

    box.find(".boxImgInner").html(thisIMg.attr("alt"));
    box.find(".boxImgInner").css("min-width", thisIMg.width() + "px")    
    box.find(".boxImgInner").show("fast");
}

function hideImgBox(thisIMg) {
    if (accGetAttributeValue(thisIMg.attr("IH")) == "") return;

    try {
        thisIMg.next().find(".boxImgInner").hide("fast", function () { killImageBox(thisIMg) });        
    }
    catch (errr) { }
}

function killImageBox(thisIMg) {
    try {
        thisIMg.next().remove();
    }
    catch (errr) { }
}

function accReset() {
    accFlickState = true;
    accChangeColorsToDefault();
    accChangeFontToDefault();
    accUnderlineLinks(0);
    accFlashMove();
    accImageHelper(0);
    accActivatelinkTurnOnAcc(0);
    accRestKeyboardActivate();
    accSetCaption();

    $("#reset")[0].focus();
}

function setLabelMessage(selector, state) {
    var message = state == "1" ? selector.attr("activeMessage") : selector.attr("defaultMessage");
    selector.attr("title", message).attr("aria-label", message).find("span").html(message);
}

function accSetCaption() {
    var accLink = $("#accLinkNew");
    var linkAcc = accGetCookie("linkAcc");
    var imageHelper = accGetCookie("imageHelper");
    var flashMoveCookie = accGetCookie("flashMove");
    var changeFontCookie = accGetCookie("changeFont");
    var underlineLinks = accGetCookie("underlineLinks");
    var changeBackgroundCookie = accGetCookie("changeBackground");

    if (linkAcc != "" || flashMoveCookie != "" || changeFontCookie != "" || changeBackgroundCookie != "" || underlineLinks != "" || imageHelper != "")
        setLabelMessage(accLink, 1);
    else
        setLabelMessage(accLink, 0);
}

function accKeyboardActivate() {
    var thisLink = $(".keyboradLinkNew");
    var keyboradStatus = accGetCookie("keyboradStatus");

    if (keyboradStatus == "") {
        accActivatelinkTurnOnAcc(1);
        accFlashMove();
        accSetCookie("keyboradStatus", "1", 1);
        setLabelMessage(thisLink, 1);

        $(".sigPad").each(function () {
            $(this).find("input").prop("checked", true);
            accSignaturePadRegenerate($(this).attr("sigPad"));
        });
    }
    else {
        accActivatelinkTurnOnAcc(0);
        accFlashMove();
        accRestKeyboardActivate();

        $(".sigPad").each(function () {
            $(this).find("input").prop("checked", false);
            accSignaturePadRegenerate($(this).attr("sigPad"));
        });
    }

    thisLink[0].focus();
}

function accRestKeyboardActivate() {
    accDeleteCookie("keyboradStatus");
    setLabelMessage($(".keyboradLinkNew"), 0);
}

function accSetAcc() {
    var linkAcc = accGetCookie("linkAcc");
    var imageHelper = accGetCookie("imageHelper");
    var flashMoveCookie = accGetCookie("flashMove");
    var changeFontCookie = accGetCookie("changeFont");
    var underlineLinks = accGetCookie("underlineLinks");
    var keyboradStatus = accGetCookie("keyboradStatus");
    var changeBackgroundCookie = accGetCookie("changeBackground");

    $(document).keyup(function (e) { if (e.keyCode == 27 && accAccState) accOpenAcc('accLinkNew', 'accDataNew'); });

    $("#accLinkNew").draggable();

    if (keyboradStatus != "" || linkAcc != "" || flashMoveCookie != "" || changeFontCookie != "" || changeBackgroundCookie != "" || underlineLinks != "" || imageHelper != "") {
        $("#accLinkNew").css("top", "0px");
        setLabelMessage($("#accLinkNew"), 1);

        if (imageHelper == "1") accImageHelper(1);
        if (changeBackgroundCookie == "0") accChangeBackground(0);
        if (changeBackgroundCookie == "1") accChangeBackground(1);
        if (changeFontCookie == "0") accChangeFont(0);
        if (changeFontCookie == "1") accChangeFont(1);
        if (linkAcc == "1") accActivatelinkTurnOnAcc(1);
        if (underlineLinks == "1") accUnderlineLinks(1);
        if (flashMoveCookie == "1") setTimeout(function () { accFlashMove(); }, 1500);
        if (keyboradStatus == "1") setLabelMessage($(".keyboradLinkNew"), 1);
    }
}

function accGetCookie(cookieName) {
    var i, x, y, ARRcookies = document.cookie.split(";");

    for (i = 0; i < ARRcookies.length; i++) {
        x = ARRcookies[i].substr(0, ARRcookies[i].indexOf("="));
        y = ARRcookies[i].substr(ARRcookies[i].indexOf("=") + 1);
        x = x.replace(/^\s+|\s+$/g, "");
        if (x == cookieName) return String(unescape(y));
    }
    return "";
}

function accDeleteCookie(cookieName) {
    accSetCookie(cookieName, "", 0);
    document.cookie = cookieName + "=; expires=Thu, 01 Jan 1970 00:00:01 GMT;";
}

function accSetCookie(cookieName, value, expiredays) {
    var exdate = new Date();
    exdate.setDate(exdate.getDate() + expiredays);
    document.cookie = cookieName + "=" + escape(value) + ((expiredays == null) ? "" : ";expires=" + exdate.toUTCString()) + ";Path=/;";
    return value;
}

(function ($) {
    if ($.fn.style) return;

    var escape = function (text) { return text.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&"); };
    var isStyleFuncSupported = !!CSSStyleDeclaration.prototype.getPropertyValue;
    if (!isStyleFuncSupported) {
        CSSStyleDeclaration.prototype.getPropertyValue = function (a) { return this.getAttribute(a); };
        CSSStyleDeclaration.prototype.setProperty = function (styleName, value, priority) {
            this.setAttribute(styleName, value);
            var priority = typeof priority != 'undefined' ? priority : '';
            if (priority != '') {
                var rule = new RegExp(escape(styleName) + '\\s*:\\s*' + escape(value) + '(\\s*;)?', 'gmi');
                this.cssText = this.cssText.replace(rule, styleName + ': ' + value + ' !' + priority + ';');
            }
        };
        CSSStyleDeclaration.prototype.removeProperty = function (a) { return this.removeAttribute(a); };
        CSSStyleDeclaration.prototype.getPropertyPriority = function (styleName) {
            var rule = new RegExp(escape(styleName) + '\\s*:\\s*[^\\s]*\\s*!important(\\s*;)?', 'gmi');
            return rule.test(this.cssText) ? 'important' : '';
        }
    }

    $.fn.style = function (styleName, value, priority) {
        var node = this.get(0);

        if (typeof node == 'undefined') return this;

        var style = this.get(0).style;

        if (typeof styleName != 'undefined') {
            if (typeof value != 'undefined') {
                priority = typeof priority != 'undefined' ? priority : '';
                style.setProperty(styleName, value, priority);
                return this;
            }
            else
                return style.getPropertyValue(styleName);
        }
        else
            return style;
    };
})(jQuery);

(function ($) {
    $.fn.inputFilter = function (inputFilter) {
        return this.on("input keydown keyup mousedown mouseup select contextmenu drop", function () {
            if (inputFilter(this.value)) {
                this.oldValue = this.value;
                this.oldSelectionStart = this.selectionStart;
                this.oldSelectionEnd = this.selectionEnd;
            }
            else if (this.hasOwnProperty("oldValue")) {
                this.value = this.oldValue;
                this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
            }
        });
    };
}(jQuery));

function accResetCssAttribute(currentElement, attrHolder, styleCssName) {
    if (currentElement.length <= 0) return;

    if (accGetAttributeValue(currentElement.attr(attrHolder)) == "") {
        var cssValue = eval("currentElement[0].style." + styleCssName);
        if (cssValue != "") {
            currentElement.attr(attrHolder, cssValue);
            if (currentElement[0].style.getPropertyPriority(styleCssName) != "") currentElement.attr(attrHolder, cssValue + " !important");
        }
        else
            currentElement.attr(attrHolder, "delete");
    }
}

function accChangeCssAttrubute(currentElement, attrHolder, styleCssName) {
    if (currentElement.length <= 0) return;

    var val = accGetAttributeValue(currentElement.attr(attrHolder));

    if (val == "delete")
        eval("currentElement[0].style." + styleCssName + "=''");
    else if (val != "")
        eval("currentElement[0].style." + styleCssName + "='" + val + "'");
}

var resizeWidthValueArray = new Array();
var resizeWidthNameArray = new Array();
function addResizeWidth(name) {
    resizeWidthNameArray.push(name);
    resizeWidthValueArray.push($(document).width());
}
function getResizeWidth(name) {
    for (var i = 0; i < resizeWidthNameArray.length; i++) {
        if (resizeWidthNameArray[i] == name) return i;
    }
    return -1;
}
function isResizeWidth(name) {
    var i = getResizeWidth(name);

    if (i == -1) return false;

    var w;

    if (!accIsIE()) {
        try { w = window.outerWidth; }
        catch (err) { w = $(document).width(); }
    }
    else
        w = $(document).width();

    if (resizeWidthValueArray[i] != w) {
        resizeWidthValueArray[i] = w;
        return true;
    }
    return false;
}
function getMobileOperatingSystem() {
    var userAgent = navigator.userAgent || navigator.vendor || window.opera;
    if (!accIsAdmin()) {        
        if (/android/i.test(userAgent)) return "and";
        if (/windows phone/i.test(userAgent)) return "win";
        if (/iPad|iPhone|iPod/.test(userAgent) && !window.MSStream) return "ios";
    }
    return "unknown";
}

function accIsIE() { return (window.navigator.userAgent.indexOf('MSIE ') > 0 || window.navigator.userAgent.indexOf('Trident/') > 0 || window.navigator.userAgent.indexOf('Edge/') > 0); }
function accIsIENoEdge() { return (window.navigator.userAgent.indexOf('MSIE ') > 0 || window.navigator.userAgent.indexOf('Trident/') > 0); }