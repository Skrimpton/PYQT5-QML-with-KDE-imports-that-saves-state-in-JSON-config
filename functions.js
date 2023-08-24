// .pragma library
function readConfig(url) {
    print(url)
    var returnText = ""
    var xhr = new XMLHttpRequest;
    xhr.open("GET", url);
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            var response = xhr.responseText;
            switch(response) {
                case '':
                    print("no json data. invalid url")
                    break;

                default:
                    fullRoot.responseXml(response)
                    break;
            }
            response = ""
        }
    };
    xhr.send();
    return returnText
}

function saveAndClose() {
    saveConfig()
    backend.closeEvent()
}

function saveConfig() {
    // print(JSON.stringify(fullRoot.config))

    config.states.pinned = fullRoot.pinned
    config.window_sizes.xHeight = fullRoot.height
    config.window_sizes.xWidth = fullRoot.width
    var newList=[]
    for (var i = 0 ; i < _mainModel.count ; i++) {
        newList.push(_mainModel.get(i))
    }
    config.url_list = newList

    var newConfig = JSON.stringify(fullRoot.config).toString()
    backend.updateConfig(newConfig)
}
