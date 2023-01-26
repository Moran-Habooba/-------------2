var skm_clockValue = 0;
var lastChildNode = null;
var slideArray = new Array();
var skm_images = new Array();
var skm_OpenMenuItems = new Array();
var skm_MenuFadeDelays = new Object();
var skm_highlightTopMenus = new Object();
var skm_SelectedMenuStyleInfos = new Object();
var skm_UnselectedMenuStyleInfos = new Object();
var positionHelper = new returnRelativeOffsetPositionCls();
var skm_ticker, slideInterval, menuDirection, visibleInterval;

function getAttr(select, attr) { return select.is("[" + attr + "]") ? select.attr(attr) : "" }
function skm_applyStyleInfoToElement(element) { if (this.className != "") element.style.className = this.className; }
function lastMenu(e, menuRootID) { $("#" + menuRootID + " a").each(function () { $(this).removeAttr("tabIndex"); }); }
function getParentMenu(thisMenu) { return $("#" + (thisMenu.attr("myparentid") + "END").replace("-subMenuEND", "")); }
function preloadimages() { for (var i = 0; i < preloadimages.arguments.length; i++) new Image().src = preloadimages.arguments[i]; }

function setMenuParameters(menuRootID, mDirection, vInterval, sInterval) {
    setTimeout(function () { setFocusLinks(menuRootID) }, 100);

    slideInterval = sInterval;
    menuDirection = mDirection;
    visibleInterval = vInterval;

    $(document).ready(function () {
        $("#" + menuRootID + " a[myparentid][myparentid!='']").each(function () {
            $(this).mouseover(function () { hoverInMenu($(this)); }).focus(function () { hoverInMenu($(this)); });
            $(this).mouseout(function () { hoverOutMenu($(this)); }).blur(function () { hoverOutMenu($(this)); })
        });
    });
}

function hoverInMenu(thisMenu) {
    var parent = getParentMenu(thisMenu);
    if (getAttr(parent, "myparentid") != "") hoverInMenu(parent);

    parent.removeAttr("class").addClass(parent.attr("onmouseover").split(";")[2].replace("this.className='", "").replace("'"));
}

function hoverOutMenu(thisMenu) {
    var parent = getParentMenu(thisMenu);
    if (getAttr(parent, "myparentid") != "") hoverOutMenu(parent);

    parent.removeAttr("class").addClass(parent.attr("onmouseout").split(";")[1].replace("this.className='", "").replace("'"));
}

function setFocusLinks(menuRootID) {
    var lastTab = 0;

    $("#" + menuRootID + " a[mytabindex]").each(function () {
        $(this).focus(function () { keydownStartMenu(menuRootID) }).blur(function (e) { lastMenu(e, menuRootID) })
        if (lastTab < parseInt($(this).attr("mytabindex"))) lastTab = parseInt($(this).attr("mytabindex"));
    });

    $("#" + menuRootID + " a[mytabindex='1']").live('keydown', function (e) {
        var keyCode = e.keyCode || e.which;
        if (keyCode == 9 && e.shiftKey) {
            $("#" + menuRootID + "Start")[0].focus();
            setTimeout(function () { $("#" + menuRootID + "Start").attr("tabindex", "-1") }, 500);
        }
    });

    $("#" + menuRootID + " a[mytabindex='" + lastTab + "']").live('keydown', function (e) {
        var keyCode = e.keyCode || e.which;
        if (keyCode == 9 && !e.shiftKey) {
            if (accIsIENoEdge()) {
                e.preventDefault();
                e.stopPropagation();
            }
            $("#" + menuRootID + "End")[0].focus();
            setTimeout(function () { $("#" + menuRootID + "End").attr("tabindex", "-1") }, 500);
        }
    });
}

function keydownStartMenu(menuRootID) {
    var list = $("#" + menuRootID + " a");
    var size = list.length;

    list.each(function () {
        if (getAttr($(this), "myTabIndex") != "") 
            $(this).attr("tabindex", parseInt($(this).attr("myTabIndex")));        
    });

    $("#" + menuRootID + "End").attr("tabindex", size);
}

function skm_mov(menuID, elem, parent, displayedVertically, imageSource) {
    skm_stopTick();
    skm_cl(elem);

    var calcWidth;
    var slideDirection;
    var calcPostion = 0;
    var childID = elem.id + "-subMenu";
    var childNode = document.getElementById(childID);

    if (childNode == null) return;

    childNode.style.viisibility = "hidden";
    childNode.style.position = "absolute";
    childNode.style.display = "inline-block";

    skm_OpenMenuItems = skm_OpenMenuItems.concat(childID);

    if (displayedVertically) {
        if (menuDirection == "ltr")
            calcWidth = parseInt(parent.offsetLeft) + parent.offsetWidth;
        else
            calcWidth = positionHelper.returnLeftPostion(parent) - childNode.offsetWidth;

        childNode.style.left = calcWidth + "px";
        childNode.style.top = positionHelper.returnTopPostion(elem) + "px";
    }
    else {
        if (menuDirection == "rtl") {           
            calcPostion = childNode.offsetWidth - elem.offsetWidth;
            if (calcPostion < 0) calcPostion = 0;
        }
        childNode.style.left = skm_getAscendingLefts(elem) - calcPostion + "px";
        childNode.style.top = skm_getAscendingTops(parent) + parent.offsetHeight + "px";
        if (childNode.offsetWidth < elem.offsetWidth) childNode.style.width = elem.offsetWidth + "px";
    }

    setMenuStyleInfos(skm_SelectedMenuStyleInfos, menuID, elem, imageSource);

    var c = $(childNode);
    
    if (parseInt(slideInterval) > 1) {
        if (lastChildNode != null) lastChildNode.stop(true, true);
        c.stop(true, true).css({ "display": "none", "viisibility": "visible" }).fadeIn(parseInt(slideInterval));
    }
    else
        c.css({ "display": "inline-block", "viisibility": "visible" });
    
    c.attr("aria-hidden", "false").attr("aria-expanded", "true");
    lastChildNode = c;
}

function setClassInfo(menuID, unselectedMenuStyleInfos, selectedMenuStyleInfos) {
    var eId = elem.id + "";
    while (eId.indexOf("-subMenu") >= 0) {
        eId = eId.substring(0, eId.lastIndexOf("-subMenu"));
        var element = document.getElementById(eId);
        element.className = unselectedMenuStyleInfos[menuID].className;
        selectedMenuStyleInfos[menuID].applyToElement(element);
    }
}

function skm_mousedOutSpacer(menuID, elem) {
    skm_doTick(menuID);
    setClassInfo(menuID, skm_UnselectedMenuStyleInfos, skm_SelectedMenuStyleInfos);
}

function setMenuStyleInfos(menuStyleInfos, menuID, elem, imageSource) {
    if (menuStyleInfos[menuID] != null) menuStyleInfos[menuID].applyToElement(elem);
    if (skm_highlightTopMenus[menuID]) setClassInfo(menuID, menuStyleInfos, menuStyleInfos);
    if (imageSource != "") setimage(elem, imageSource);
}

function skm_mou(menuID, elem, imageSource) {
    skm_doTick(menuID);
    setMenuStyleInfos(skm_UnselectedMenuStyleInfos, menuID, elem, imageSource);
}

function slideObject(menuID, direction) {
    this.menuID = menuID;
    this.direction = direction;
}

function getSlide(menuID) {
    for (var i = 0; i < slideArray.length; i++) if (menuID == slideArray[i].menuID) return slideArray[i];
    return null;
}

function addSlide(menuID, direction) {
    for (var i = 0; i < slideArray.length; i++) if (menuID == slideArray[i].menuID) return;
    slideArray[slideArray.length] = new slideObject(menuID, direction);
}

function skm_registerMenu(menuID, selectedStyleInfo, unselectedStyleInfo, menuFadeDelay, highlightTopMenu) {
    skm_MenuFadeDelays[menuID] = menuFadeDelay;
    skm_highlightTopMenus[menuID] = highlightTopMenu;
    skm_SelectedMenuStyleInfos[menuID] = selectedStyleInfo;
    skm_UnselectedMenuStyleInfos[menuID] = unselectedStyleInfo;
}

function skm_styleInfo(className) {
    this.className = className;
    this.applyToElement = skm_applyStyleInfoToElement;
}

function skm_mousedOverClickToOpen(menuID, elem, parent, imageSource) {
    skm_stopTick();
    setMenuStyleInfos(skm_SelectedMenuStyleInfos, menuID, elem, imageSource);
}

function skm_mousedOverSpacer(menuID, elem, parent) {
    skm_stopTick();
    setMenuStyleInfos(skm_SelectedMenuStyleInfos, menuID, elem, imageSource);
}

function skm_cl(parent) {
    if (skm_OpenMenuItems == "undefined") return;
    for (var i = skm_OpenMenuItems.length - 1; i > -1; i--) {
        if (parent.id.indexOf(skm_OpenMenuItems[i]) != 0) {
            var m = $("#" + skm_OpenMenuItems[i]);

            if (parseInt(slideInterval) > 1) {
                if (lastChildNode != null) lastChildNode.stop(true, true);
                m.stop(true, true).fadeOut(parseInt(visibleInterval));
            }
            else
                m.css("display", "none");

            m.attr("aria-hidden", "true").attr("aria-expanded", "false");

            skm_vis(false, skm_OpenMenuItems[i]);
            skm_OpenMenuItems = new Array().concat(skm_OpenMenuItems.slice(0, i), skm_OpenMenuItems.slice(i + 1));
        }
    }
}

function skm_vis(makevisible, tableid) {
    var tblRef = document.getElementById(tableid);
    var ifrRef = document.getElementById("shim" + tableid);
    if (tblRef != null && ifrRef != null) {
        if (makevisible) {
            var px = "px";
            if (document.getElementsByTagName && document.all) px = "";
            ifrRef.style.display = "inline-block";
            ifrRef.style.width = tblRef.offsetWidth;
            ifrRef.style.top = tblRef.style.top + px;
            ifrRef.style.height = tblRef.offsetHeight;
            ifrRef.style.left = tblRef.style.left + px;
            ifrRef.style.zIndex = tblRef.style.zIndex - 1;
            $(ifrRef).attr("aria-hidden", "false");            
        }
        else {
            ifrRef.style.display = "none";
            $(ifrRef).attr("aria-hidden", "true");            
        }
    }
}

function skm_IsSubMenu(id) {
    if (typeof (skm_subMenuIDs) == "undefined") return false;
    for (var i = 0; i < skm_subMenuIDs.length; i++) if (id == skm_subMenuIDs[i]) return true;
    return false;
}

function skm_getAscendingLefts(elem) {
    if (elem == null) return 0;
    if ((elem.style.position == "absolute" || elem.style.position == "relative") && !skm_IsSubMenu(elem.id)) return 0;
    return elem.offsetLeft + skm_getAscendingLefts(elem.offsetParent);
}

function skm_getAscendingTops(elem) {
    if (elem == null) return 0;
    if ((elem.style.position == "absolute" || elem.style.position == "relative") && !skm_IsSubMenu(elem.id)) return 0;
    return elem.offsetTop + skm_getAscendingTops(elem.offsetParent);
}

function skm_doTick(menuID) {
    if (skm_clockValue >= skm_MenuFadeDelays[menuID]) {
        skm_stopTick();
        skm_cl(document.getElementById(menuID));
    }
    else {
        skm_clockValue++;
        skm_ticker = setTimeout(function () { skm_doTick(menuID) }, parseInt(visibleInterval));
    }
}

function skm_stopTick() {
    skm_clockValue = 0;
    clearTimeout(skm_ticker);
}

function setimage(elem, imageSource) {
    var img = elem.getElementsByTagName("img")[0];
    if (img) img.src = imageSource;
}

function returnRelativeOffsetPositionCls() {
    this.returnTopPostion = returnTopPostion;
    this.returnLeftPostion = returnLeftPostion;

    function returnLeftPostion(objectId) {
        if (objectId.tagName.toLowerCase() == "html") objectId = document.getElementsByTagName("body")[0];
        if (objectId.tagName.toLowerCase() == "body") return parseInt(objectId.offsetLeft);
        return objectId.offsetLeft + returnLeftPostion(objectId.offsetParent);
    }

    function returnTopPostion(objectId) {
        if (objectId.tagName.toLowerCase() == "html") objectId = document.getElementsByTagName("body")[0];
        if (objectId.tagName.toLowerCase() == "body") return (objectId.offsetTop);
        return objectId.offsetTop + returnTopPostion(objectId.offsetParent);
    }
}