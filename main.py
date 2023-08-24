#!/bin/env python3
# https://www.pythonguis.com/tutorials/qml-qtquick-python-application/
# https://stackoverflow.com/a/53274707
import os
import sys
import signal

# from configparser import ConfigParser

from PyQt5.QtGui import QGuiApplication, QIcon
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QTimer, QObject, pyqtSignal, pyqtSlot

from time import strftime, localtime

path_current_directory = os.path.dirname(__file__)
conf_json = os.path.join(path_current_directory, 'config.json')

class Cfg:
    def returnKeyValue(cat,k):
        with open("config.json", "r") as f:
            try:
                conf_data = json.load(f)
                # print("returnKey",conf_data[cat][k])
                return conf_data[cat][k]

            except JSONDecodeError:
                pass
        f.close()

    def editKeyAndValue(cat , k, val):
        with open(conf_json, 'r') as f:
            json_data = json.load(f)
            json_data[cat][k]=val
        f.close()

        with open(conf_json, 'w') as f:
            json.dump(json_data, f, indent=2)

        f.close()

    def removIndexUrl(index):
        with open(conf_json, 'r') as f:
            json_data = json.load(f)

        i = 0
        for a in json_data['url_list']:
            if i == index:
                del json_data['url_list'][i]
            i += 1

        f.close()

        with open(conf_json, 'w') as f:
            json.dump(json_data, f, indent=2)

        f.close()

    def removMatchKeyAndVal(key,val):
        with open(conf_json, 'r') as f:
            json_data = json.load(f)

        i = 0
        for a in json_data['url_list']:
            if [a][key] == val:
                del json_data['url_list'][i]
            i += 1

        f.close()

        with open(conf_json, 'w') as f:
            json.dump(json_data, f, indent=2)

        f.close()


    # def removeKey(k):
    #     with open(conf_json, 'r+') as f:
    #         json_data = json.load(f)
    #
    #     f.close()


class Backend(QObject):

    updated = pyqtSignal(str, arguments=['time'])
    # readConfig = pyqtSignal()
    interrupt = pyqtSignal()
    updateList = pyqtSignal()

    def __init__(self):
        super().__init__()

        # Define timer.
        self.timer = QTimer()
        self.timer.setInterval(100)  # msecs 100 = 1/10th sec
        self.timer.timeout.connect(self.update_time)
        self.timer.start()


    # def load_config(self):
    #     self.readConfig.emit()

    def update_time(self):
        # Pass the current time to QML.
        curr_time = strftime("%H:%M:%S", localtime())
        self.updated.emit(curr_time)

    def update_list(self):
        self.updateList.emit()

    def closeEventInterrupt(self, *args):
        self.interrupt.emit()

    @pyqtSlot()
    def closeEvent(self):
        print("python exit signal recieved")
        app.quit()

    @pyqtSlot(str)
    def updateConfig(self,obj):
        # print(obj)

        with open(conf_json, 'w') as f:
            new_json = json.loads(obj)
            json.dump(new_json, f, indent=2)
        f.close()

    @pyqtSlot(str)
    def outputStr(self, s):
        print(s)

    @pyqtSlot()
    def btnClick(self):
        pass

    @pyqtSlot(str,str)
    def saveSize(self, w, h):
        Cfg.editKeyAndValue("window_sizes","xWidth",w)
        Cfg.editKeyAndValue("window_sizes","xHeight",h)
        # print(Cfg.returnKeyValue("window_sizes","xWidth"))
        # print(Cfg.returnKeyValue("window_sizes","xHeight"))

        # _w = Cfg.returnKeyValue("window_sizes","xWidth")
        # _h = Cfg.returnKeyValue("window_sizes","xWidth")
        # engine.rootObjects()[0].setProperty('xHeight', _h)
        # engine.rootObjects()[0].setProperty('xWidth', _w)

    @pyqtSlot(result=str)
    def val(self):
        self.c = get_config(conf_ini)
        self.r = list(self.c.items('main'))
        return self.r[0][1]

def quitApp(*args):
    app.quit()
    sys.exit()

if __name__ == '__main__':

    import json
    from json.decoder import JSONDecodeError

    # signal.signal(signal.SIGINT, signal.SIG_DFL)

    app = QGuiApplication(sys.argv)
    app.setWindowIcon(QIcon("data-wave.svg"));
    engine = QQmlApplicationEngine()
    engine.quit.connect(app.quit)
    engine.load('main.qml')
    backend = Backend()
    signal.signal(signal.SIGINT, backend.closeEventInterrupt)

    def returnDefaultJSON():

        loaded = {}

        #overwrite/create file
        loaded["states"] = {
            "pinned":True
        }
        loaded["url_list"] = []
        loaded["window_sizes"] = {
            "xHeight":200,
            "xWidth": 350
        }
        return loaded

    if not os.path.exists(conf_json):
        with open(conf_json, 'w') as f:
            print("adding default values")
            loaded = returnDefaultJSON()
            json.dump(loaded,f,indent=2)
        f.close()

    else:
        with open(conf_json, 'r+') as f: # , open(filename, 'w') as outfile:
            try:
                old_data = json.load(f)
                old_data = ""
            except JSONDecodeError as jdcerr:
                is_empty = bool(str(jdcerr).strip().__contains__("Expecting value:"))
                if is_empty:
                    loaded = returnDefaultJSON()
                    json.dump(loaded,f,indent=2)

        f.close()




    with open(conf_json, "r") as f:
        try:
            conf_data = json.load(f)
        except JSONDecodeError as jdcerr:
            print(jdcerr)
            pass
    f.close()

    try:
        x_w = conf_data['window_sizes']['xWidth']
        x_h = conf_data['window_sizes']['xHeight']
        pinned = conf_data['states']['pinned']

        engine.rootObjects()[0].setProperty('xHeight', x_h)
        engine.rootObjects()[0].setProperty('xWidth', x_w)
        engine.rootObjects()[0].setProperty('configPath', conf_json)
        engine.rootObjects()[0].setProperty('config', conf_data)
        engine.rootObjects()[0].setProperty('pinned', pinned)
        engine.rootObjects()[0].setProperty('backend', backend)

        # Initial call to trigger first update. Must be after the setProperty to connect signals.
        backend.update_time()
        backend.update_list()

        sys.exit(app.exec())

    except NameError as nmerr:
        print(nmerr)
        pass

    except JSONDecodeError as jdcerr:
        print(jdcerr)
        pass
    # backend.load_config()






# Connect your cleanup function to signal.SIGINT
# And start a timer to call Application.event repeatedly.
# You can change the timer parameter as you like.


