import sys
import os

from PyQt5.QtWidgets import QWidget,QApplication,QTextEdit,QLabel,QPushButton,QVBoxLayout,QFileDialog,QHBoxLayout

from PyQt5.QtWidgets import QAction,qApp,QMainWindow

class Notepad(QWidget):
    def __init__(self):

        super().__init__()

        self.init_ui()
    def init_ui(self):

        self.textarea = QTextEdit()

        self.ClearButton = QPushButton("Clear")
        self.OpenButton = QPushButton("Open")
        self.SaveButton = QPushButton("Save As")

        h_box = QHBoxLayout()

        h_box.addWidget(self.ClearButton)
        h_box.addWidget(self.OpenButton)
        h_box.addWidget(self.SaveButton)

        v_box = QVBoxLayout()

        v_box.addWidget(self.textarea)

        v_box.addLayout(h_box)

        self.setLayout(v_box)

        self.setWindowTitle("NotePad")
        self.ClearButton.clicked.connect(self.ClearTextArea)
        self.OpenButton.clicked.connect(self.FileOpen)
        self.SaveButton.clicked.connect(self.FileSave)




    def ClearTextArea(self):
        self.textarea.clear()

    def FileOpen(self):
        filename = QFileDialog.getOpenFileName(self,"File Open",os.getenv("HOME"))

        with open(filename[0],"r") as file:
            self.yazi_alani.setText(file.read())

    def FileSave(self):
        filename = QFileDialog.getSaveFileName(self,"File Save",os.getenv("HOME"))

        with open(filename[0],"w") as file:

            file.write(self.textarea.toPlainText())

class Menu(QMainWindow):

    def __init__(self):

        super().__init__()

        self.windows = Notepad()
        self.setCentralWidget(self.windows)
        self.createMenus()

    def createMenus(self):

        menus = self.menuBar()

        files = menus.addMenu("File")
        edits = menus.addMenu("Edit")

        FileOpen = QAction("Open file", self)
        FileOpen.setShortcut("Ctrl+O")

        FileSave = QAction("Save As", self)
        FileSave.setShortcut("Ctrl+S")

        Clear = QAction("Clear File", self)
        Clear.setShortcut("Ctrl+D")

        Exit = QAction("Çıkış",self)
        Exit.setShortcut("Ctrl+Q")

        files.addAction(FileOpen)
        files.addAction(FileSave)
        edits.addAction(Clear)
        files.addAction(Exit)

        files.triggered.connect(self.response)


        self.setWindowTitle("Text Editor")
        self.show()

    def response(self, action):

        if action.text() == "Open File":
            self.windows.FileOpen()

        elif action.text() == "Save As":
            self.windows.FileSave()
        elif action.text() == "Clear File":
            self.windows.ClearTextArea()

        elif action.text() == "Exit":
            qApp.quit()








app = QApplication(sys.argv)
menu = Menu()
sys.exit(app.exec_())