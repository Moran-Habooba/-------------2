var SmartPagerID;

function changeCss(thisObject, cssName, prefix) {
    try {
        if (prefix == "")
            thisObject.className = cssName;
        else
            thisObject.className = cssName + " " + cssName + prefix;
    }
    catch (e) { }
}

function SmartPagerSelectPage(id, pageNo) {
    if (eval(id + "$callJS") != "")
        eval(eval(id + "$callJS") + "('" + id + "', " + pageNo + ")");
    else {
        document.getElementById("hdn" + id).value = pageNo;
        document.getElementById("hdn" + id).form.submit();
    }
}

function showPager(srcEl) {
    var pgrLayerObject = document.getElementById('pgrLayer');

    pgrLayerObject.style.left = parseInt(srcEl.offsetLeft);
    pgrLayerObject.style.top = parseInt(srcEl.offsetTop);
    pgrLayerObject.style.visibility = "visible";
    pgrLayerObject.getElementsByTagName("INPUT")[0].value = "";
    pgrLayerObject.getElementsByTagName("INPUT")[0].style.backgroundColor = "";
    pgrLayerObject.getElementsByTagName("INPUT")[0].style.color = "";
    pgrLayerObject.getElementsByTagName("INPUT")[0].focus();
    updateLabel()
}

function goToPage() {
    var tb = document.getElementById('pgrLayer').getElementsByTagName("INPUT")[0];
    var pagerPageCount = eval(SmartPagerID + "$pagerPageCount");

    if (parseInt(tb.value) != tb.value || parseInt(tb.value) > pagerPageCount) {
        tb.style.backgroundColor = "#c00";
        tb.style.color = "white";
        tb.focus();
        return;
    }

    tb.blur();
    document.getElementById('pgrLayer').style.visibility = "hidden";
    SmartPagerSelectPage(SmartPagerID, tb.value);
}

function pagerTbKd(e) {
    var tb = document.getElementById('pgrLayer').getElementsByTagName("INPUT")[0];
    var pagerPageCount = eval(SmartPagerID + "$pagerPageCount");

    tb.style.backgroundColor = "";
    tb.style.color = "";

    if (e.keyCode == 27) {
        tb.blur();
        document.getElementById('pgrLayer').style.visibility = "hidden";
    }
    else if (e.keyCode == 13) {
        goToPage();

        if (window.event)
            e.returnValue = false;
        else
            e.preventDefault();
    }
    else if (e.keyCode == 38) {
        var current = (isNaN(parseInt(tb.value))) ? 0 : parseInt(tb.value);
        if (current < 1)
            tb.value = 1;
        else if (current < pagerPageCount)
            tb.value = current + 1;
        else
            tb.value = pagerPageCount;

        updateLabel(parseInt(tb.value));
    }
    else if (e.keyCode == 40) {
        var current = (isNaN(parseInt(tb.value))) ? 2 : parseInt(tb.value);
        if (current > 1)
            tb.value = current - 1;
        else if (current > pagerPageCount)
            tb.value = pagerPageCount;
        else
            tb.value = 1;
        updateLabel(parseInt(tb.value));
    }
    else
        setTimeout("updateLabel()", 50);
}

function pagerPreventSubmit(e) {
    if (e.keyCode == 13) {
        if (window.event)
            e.returnValue = false;
        else
            e.preventDefault();
    }
    else {
        if (window.event) {
            if (e.keyCode < 48 || e.keyCode > 57)
                e.returnValue = false;
        }
        else {
            if (e.keyCode == 0 && (e.charCode < 48 || e.charCode > 57))
                e.preventDefault();
        }
    }
}

function updateLabel() {
    var tb = document.getElementById('pgrLayer').getElementsByTagName("INPUT")[0];
    var pagerPageCount = eval(SmartPagerID + "$pagerPageCount");
    var current = parseInt(tb.value);

    if (!isNaN(current) && current == tb.value && current > 0 && current <= pagerPageCount) {
        var tooltipText = eval(SmartPagerID + "$tooltipsArr[" + (current - 1) + "]") + "";
        if (tooltipText != "undefined" && tooltipText.length > 0) {
            document.getElementById("pgrPreviewLabel").innerHTML = tooltipText;
            document.getElementById("pgrPreviewLabel").style.marginTop = "3px";
            return;
        }
    }

    document.getElementById("pgrPreviewLabel").innerHTML = "<img src='images/spacer.gif' width='1' height='1' alt='' title=''/><br/>";
    document.getElementById("pgrPreviewLabel").style.marginTop = "0";
}