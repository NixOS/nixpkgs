// Copyright (C) 2016 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0+ OR GPL-3.0 WITH Qt-GPL-exception-1.0

#include "icore.h"

#include "coreplugintr.h"
#include "dialogs/settingsdialog.h"
#include "windowsupport.h"

#include <app/app_version.h>

#include <extensionsystem/pluginmanager.h>

#include <utils/algorithm.h>
#include <utils/environment.h>
#include <utils/fileutils.h>
#include <utils/qtcassert.h>

#include <QApplication>
#include <QDebug>
#include <QLibraryInfo>
#include <QStandardPaths>
#include <QSysInfo>

/*!
    \namespace Core
    \inmodule QtCreator
    \brief The Core namespace contains all classes that make up the Core plugin
    which constitute the basic functionality of \QC.
*/

/*!
    \enum Core::FindFlag
    This enum holds the find flags.

    \value FindBackward
           Searches backwards.
    \value FindCaseSensitively
           Considers case when searching.
    \value FindWholeWords
           Finds only whole words.
    \value FindRegularExpression
           Uses a regular epression as a search term.
    \value FindPreserveCase
           Preserves the case when replacing search terms.
*/

/*!
    \enum Core::ICore::ContextPriority

    This enum defines the priority of additional contexts.

    \value High
           Additional contexts that have higher priority than contexts from
           Core::IContext instances.
    \value Low
           Additional contexts that have lower priority than contexts from
           Core::IContext instances.

    \sa Core::ICore::updateAdditionalContexts()
*/

/*!
    \enum Core::SaveSettingsReason
    \internal
*/

/*!
    \namespace Core::Internal
    \internal
*/

/*!
    \class Core::ICore
    \inheaderfile coreplugin/icore.h
    \inmodule QtCreator
    \ingroup mainclasses

    \brief The ICore class allows access to the different parts that make up
    the basic functionality of \QC.

    You should never create a subclass of this interface. The one and only
    instance is created by the Core plugin. You can access this instance
    from your plugin through instance().
*/

/*!
    \fn void Core::ICore::coreAboutToOpen()

    Indicates that all plugins have been loaded and the main window is about to
    be shown.
*/

/*!
    \fn void Core::ICore::coreOpened()
    Indicates that all plugins have been loaded and the main window is shown.
*/

/*!
    \fn void Core::ICore::saveSettingsRequested(Core::ICore::SaveSettingsReason reason)
    Signals that the user has requested that the global settings
    should be saved to disk for a \a reason.

    At the moment that happens when the application is closed, and on \uicontrol{Save All}.
*/

/*!
    \fn void Core::ICore::coreAboutToClose()
    Enables plugins to perform some pre-end-of-life actions.

    The application is guaranteed to shut down after this signal is emitted.
    It is there as an addition to the usual plugin lifecycle functions, namely
    \c IPlugin::aboutToShutdown(), just for convenience.
*/

/*!
    \fn void Core::ICore::contextAboutToChange(const QList<Core::IContext *> &context)
    Indicates that a new \a context will shortly become the current context
    (meaning that its widget got focus).
*/

/*!
    \fn void Core::ICore::contextChanged(const Core::Context &context)
    Indicates that a new \a context just became the current context. This includes the context
    from the focus object as well as the additional context.
*/

#include "dialogs/newdialogwidget.h"
#include "dialogs/newdialog.h"
#include "iwizardfactory.h"
#include "mainwindow.h"
#include "documentmanager.h"

#include <utils/hostosinfo.h>

#include <QCoreApplication>
#include <QDebug>
#include <QDir>
#include <QMessageBox>
#include <QPushButton>
#include <QStatusBar>

using namespace Core::Internal;
using namespace ExtensionSystem;
using namespace Utils;

namespace Core {

// The Core Singleton
static ICore *m_instance = nullptr;
static MainWindow *m_mainwindow = nullptr;

static NewDialog *defaultDialogFactory(QWidget *parent)
{
    return new NewDialogWidget(parent);
}

static std::function<NewDialog *(QWidget *)> m_newDialogFactory = defaultDialogFactory;

/*!
    Returns the pointer to the instance. Only use for connecting to signals.
*/
ICore *ICore::instance()
{
    return m_instance;
}

/*!
    Returns whether the new item dialog is currently open.
*/
bool ICore::isNewItemDialogRunning()
{
    return NewDialog::currentDialog() || IWizardFactory::isWizardRunning();
}

/*!
    Returns the currently open new item dialog widget, or \c nullptr if there is none.

    \sa isNewItemDialogRunning()
    \sa showNewItemDialog()
*/
QWidget *ICore::newItemDialog()
{
    if (NewDialog::currentDialog())
        return NewDialog::currentDialog();
    return IWizardFactory::currentWizard();
}

/*!
    \internal
*/
ICore::ICore(MainWindow *mainwindow)
{
    m_instance = this;
    m_mainwindow = mainwindow;
    // Save settings once after all plugins are initialized:
    connect(PluginManager::instance(), &PluginManager::initializationDone,
            this, [] { ICore::saveSettings(ICore::InitializationDone); });
    connect(PluginManager::instance(), &PluginManager::testsFinished, [this] (int failedTests) {
        emit coreAboutToClose();
        if (failedTests != 0)
            qWarning("Test run was not successful: %d test(s) failed.", failedTests);
        QCoreApplication::exit(failedTests);
    });
    connect(PluginManager::instance(), &PluginManager::scenarioFinished, [this] (int exitCode) {
        emit coreAboutToClose();
        QCoreApplication::exit(exitCode);
    });

    FileUtils::setDialogParentGetter(&ICore::dialogParent);
}

/*!
    \internal
*/
ICore::~ICore()
{
    m_instance = nullptr;
    m_mainwindow = nullptr;
}

/*!
    Opens a dialog where the user can choose from a set of \a factories that
    create new files or projects.

    The \a title argument is shown as the dialog title. The path where the
    files will be created (if the user does not change it) is set
    in \a defaultLocation. Defaults to DocumentManager::projectsDirectory()
    or DocumentManager::fileDialogLastVisitedDirectory(), depending on wizard
    kind.

    Additional variables for the wizards are set in \a extraVariables.

    \sa Core::DocumentManager
    \sa isNewItemDialogRunning()
    \sa newItemDialog()
*/
void ICore::showNewItemDialog(const QString &title,
                              const QList<IWizardFactory *> &factories,
                              const FilePath &defaultLocation,
                              const QVariantMap &extraVariables)
{
    QTC_ASSERT(!isNewItemDialogRunning(), return);

    /* This is a workaround for QDS: In QDS, we currently have a "New Project" dialog box but we do
     * not also have a "New file" dialog box (yet). Therefore, when requested to add a new file, we
     * need to use QtCreator's dialog box. In QDS, if `factories` contains project wizard factories
     * (even though it may contain file wizard factories as well), then we consider it to be a
     * request for "New Project". Otherwise, if we only have file wizard factories, we defer to
     * QtCreator's dialog and request "New File"
     */
    auto dialogFactory = m_newDialogFactory;
    bool haveProjectWizards = Utils::anyOf(factories, [](IWizardFactory *f) {
        return f->kind() == IWizardFactory::ProjectWizard;
    });

    if (!haveProjectWizards)
        dialogFactory = defaultDialogFactory;

    NewDialog *newDialog = dialogFactory(dialogParent());
    connect(newDialog->widget(), &QObject::destroyed, m_instance, &ICore::updateNewItemDialogState);
    newDialog->setWizardFactories(factories, defaultLocation, extraVariables);
    newDialog->setWindowTitle(title);
    newDialog->showDialog();

    updateNewItemDialogState();
}

/*!
    Opens the options dialog on the specified \a page. The dialog's \a parent
    defaults to dialogParent(). If the dialog is already shown when this method
    is called, it is just switched to the specified \a page.

    Returns whether the user accepted the dialog.

    \sa msgShowOptionsDialog()
    \sa msgShowOptionsDialogToolTip()
*/
bool ICore::showOptionsDialog(const Id page, QWidget *parent)
{
    return executeSettingsDialog(parent ? parent : dialogParent(), page);
}

/*!
    Returns the text to use on buttons that open the options dialog.

    \sa showOptionsDialog()
    \sa msgShowOptionsDialogToolTip()
*/
QString ICore::msgShowOptionsDialog()
{
    return Tr::tr("Configure...", "msgShowOptionsDialog");
}

/*!
    Returns the tool tip to use on buttons that open the options dialog.

    \sa showOptionsDialog()
    \sa msgShowOptionsDialog()
*/
QString ICore::msgShowOptionsDialogToolTip()
{
    if (Utils::HostOsInfo::isMacHost())
        return Tr::tr("Open Preferences dialog.", "msgShowOptionsDialogToolTip (mac version)");
    else
        return Tr::tr("Open Options dialog.", "msgShowOptionsDialogToolTip (non-mac version)");
}

/*!
    Creates a message box with \a parent that contains a \uicontrol Configure
    button for opening the settings page specified by \a settingsId.

    The dialog has \a title and displays the message \a text and detailed
    information specified by \a details.

    Use this function to display configuration errors and to point users to the
    setting they should fix.

    Returns \c true if the user accepted the settings dialog.

    \sa showOptionsDialog()
*/
bool ICore::showWarningWithOptions(const QString &title, const QString &text,
                                   const QString &details, Id settingsId, QWidget *parent)
{
    if (!parent)
        parent = m_mainwindow;
    QMessageBox msgBox(QMessageBox::Warning, title, text,
                       QMessageBox::Ok, parent);
    msgBox.setEscapeButton(QMessageBox::Ok);
    if (!details.isEmpty())
        msgBox.setDetailedText(details);
    QAbstractButton *settingsButton = nullptr;
    if (settingsId.isValid())
        settingsButton = msgBox.addButton(msgShowOptionsDialog(), QMessageBox::AcceptRole);
    msgBox.exec();
    if (settingsButton && msgBox.clickedButton() == settingsButton)
        return showOptionsDialog(settingsId);
    return false;
}

/*!
    Returns the application's main settings object.

    You can use it to retrieve or set application-wide settings
    (in contrast to session or project specific settings).

    If \a scope is \c QSettings::UserScope (the default), the
    settings will be read from the user's settings, with
    a fallback to global settings provided with \QC.

    If \a scope is \c QSettings::SystemScope, only the installation settings
    shipped with the current version of \QC will be read. This
    functionality exists for internal purposes only.

    \sa settingsDatabase()
*/
QtcSettings *ICore::settings(QSettings::Scope scope)
{
    if (scope == QSettings::UserScope)
        return PluginManager::settings();
    else
        return PluginManager::globalSettings();
}

/*!
    Returns the application's settings database.

    The settings database is meant as an alternative to the regular settings
    object. It is more suitable for storing large amounts of data. The settings
    are application wide.

    \sa SettingsDatabase
    \sa settings()
*/
SettingsDatabase *ICore::settingsDatabase()
{
    return m_mainwindow->settingsDatabase();
}

/*!
    Returns the application's printer object.

    Always use this printer object for printing, so the different parts of the
    application re-use its settings.
*/
QPrinter *ICore::printer()
{
    return m_mainwindow->printer();
}

/*!
    Returns the locale string for the user interface language that is currently
    configured in \QC. Use this to install your plugin's translation file with
    QTranslator.
*/
QString ICore::userInterfaceLanguage()
{
    return qApp->property("qtc_locale").toString();
}

static QString pathHelper(const QString &rel)
{
    if (rel.isEmpty())
        return rel;
    if (rel.startsWith('/'))
        return rel;
    return '/' + rel;
}
/*!
    Returns the absolute path for the relative path \a rel that is used for resources like
    project templates and the debugger macros.

    This abstraction is needed to avoid platform-specific code all over
    the place, since on \macos, for example, the resources are part of the
    application bundle.

    \sa userResourcePath()
*/
FilePath ICore::resourcePath(const QString &rel)
{
    qWarning() << "ICore::resourcePath: QCoreApplication::applicationDirPath() = " << QCoreApplication::applicationDirPath();
    qWarning() << "ICore::resourcePath: QDir::cleanPath(QCoreApplication::applicationDirPath()) = " << QDir::cleanPath(QCoreApplication::applicationDirPath());
    qWarning() << "ICore::resourcePath: RELATIVE_DATA_PATH = " << RELATIVE_DATA_PATH;
    qWarning() << "ICore::resourcePath: rel = " << rel;
    return FilePath::fromString(
               QDir::cleanPath(QCoreApplication::applicationDirPath() + '/' + RELATIVE_DATA_PATH))
           / rel;
}

/*!
    Returns the absolute path for the relative path \a rel in the users directory that is used for
    resources like project templates.

    Use this function for finding the place for resources that the user may
    write to, for example, to allow for custom palettes or templates.

    \sa resourcePath()
*/

FilePath ICore::userResourcePath(const QString &rel)
{
    // Create qtcreator dir if it doesn't yet exist
    const QString configDir = QFileInfo(settings(QSettings::UserScope)->fileName()).path();
    const QString urp = configDir + '/' + QLatin1String(Constants::IDE_ID);

    if (!QFileInfo::exists(urp + QLatin1Char('/'))) {
        QDir dir;
        if (!dir.mkpath(urp))
            qWarning() << "could not create" << urp;
    }

    return FilePath::fromString(urp + pathHelper(rel));
}

/*!
    Returns a writable path for the relative path \a rel that can be used for persistent cache files.
*/
FilePath ICore::cacheResourcePath(const QString &rel)
{
    return FilePath::fromString(QStandardPaths::writableLocation(QStandardPaths::CacheLocation)
                                + pathHelper(rel));
}

/*!
    Returns the path, based on the relative path \a rel, to resources written by the installer,
    for example pre-defined kits and toolchains.
*/
FilePath ICore::installerResourcePath(const QString &rel)
{
    return FilePath::fromString(settings(QSettings::SystemScope)->fileName()).parentDir()
                                / Constants::IDE_ID / rel;
}

/*!
    Returns the path to the plugins that are included in the \QC installation.

    \internal
*/
QString ICore::pluginPath()
{
    qWarning() << "ICore::pluginPath: QCoreApplication::applicationDirPath() = " << QCoreApplication::applicationDirPath();
    qWarning() << "ICore::pluginPath: QDir::cleanPath(QCoreApplication::applicationDirPath()) = " << QDir::cleanPath(QCoreApplication::applicationDirPath());
    qWarning() << "ICore::pluginPath: RELATIVE_PLUGIN_PATH = " << RELATIVE_PLUGIN_PATH;
    return QDir::cleanPath(QCoreApplication::applicationDirPath() + '/' + RELATIVE_PLUGIN_PATH);
}

/*!
    Returns the path where user-specific plugins should be written.

    \internal
*/
QString ICore::userPluginPath()
{
    QString pluginPath = QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation);
    if (Utils::HostOsInfo::isAnyUnixHost() && !Utils::HostOsInfo::isMacHost())
        pluginPath += "/data";
    pluginPath += '/' + QLatin1String(Core::Constants::IDE_SETTINGSVARIANT_STR) + '/';
    pluginPath += QLatin1String(Utils::HostOsInfo::isMacHost() ? Core::Constants::IDE_DISPLAY_NAME
                                                               : Core::Constants::IDE_ID);
    pluginPath += "/plugins/";
    pluginPath += QString::number(IDE_VERSION_MAJOR) + '.' + QString::number(IDE_VERSION_MINOR)
                  + '.' + QString::number(IDE_VERSION_RELEASE);
    return pluginPath;
}

/*!
    Returns the path, based on the relative path \a rel, to the command line tools that are
    included in the \QC installation.
 */
FilePath ICore::libexecPath(const QString &rel)
{
    return FilePath::fromString(QDir::cleanPath(QApplication::applicationDirPath()
                                                + pathHelper(RELATIVE_LIBEXEC_PATH)))
           / rel;
}

FilePath ICore::crashReportsPath()
{
    if (Utils::HostOsInfo::isMacHost())
        return libexecPath("crashpad_reports/completed");
    else
        return libexecPath("crashpad_reports/reports");
}

QString ICore::ideDisplayName()
{
    return Constants::IDE_DISPLAY_NAME;
}

static QString clangIncludePath(const QString &clangVersion)
{
    return "/lib/clang/" + clangVersion + "/include";
}

/*!
    \internal
*/
FilePath ICore::clangIncludeDirectory(const QString &clangVersion,
                                      const FilePath &clangFallbackIncludeDir)
{
    FilePath dir = libexecPath("clang" + clangIncludePath(clangVersion));
    if (!dir.exists() || !dir.pathAppended("stdint.h").exists())
        dir = clangFallbackIncludeDir;
    return dir.canonicalPath();
}

/*!
    \internal
*/
static FilePath clangBinary(const QString &binaryBaseName, const FilePath &clangBinDirectory)
{
    FilePath executable =
        ICore::libexecPath("clang/bin").pathAppended(binaryBaseName).withExecutableSuffix();
    if (!executable.exists())
        executable = clangBinDirectory.pathAppended(binaryBaseName).withExecutableSuffix();
    return executable.canonicalPath();
}

/*!
    \internal
*/
FilePath ICore::clangExecutable(const FilePath &clangBinDirectory)
{
    return clangBinary("clang", clangBinDirectory);
}

/*!
    \internal
*/
FilePath ICore::clangdExecutable(const FilePath &clangBinDirectory)
{
    return clangBinary("clangd", clangBinDirectory);
}

/*!
    \internal
*/
FilePath ICore::clangTidyExecutable(const FilePath &clangBinDirectory)
{
    return clangBinary("clang-tidy", clangBinDirectory);
}

/*!
    \internal
*/
FilePath ICore::clazyStandaloneExecutable(const FilePath &clangBinDirectory)
{
    return clangBinary("clazy-standalone", clangBinDirectory);
}

static QString compilerString()
{
#if defined(Q_CC_CLANG) // must be before GNU, because clang claims to be GNU too
    QString platformSpecific;
#if defined(__apple_build_version__) // Apple clang has other version numbers
    platformSpecific = QLatin1String(" (Apple)");
#elif defined(Q_CC_MSVC)
    platformSpecific = QLatin1String(" (clang-cl)");
#endif
    return QLatin1String("Clang " ) + QString::number(__clang_major__) + QLatin1Char('.')
            + QString::number(__clang_minor__) + platformSpecific;
#elif defined(Q_CC_GNU)
    return QLatin1String("GCC " ) + QLatin1String(__VERSION__);
#elif defined(Q_CC_MSVC)
    if (_MSC_VER > 1999)
        return QLatin1String("MSVC <unknown>");
    if (_MSC_VER >= 1930)
        return QLatin1String("MSVC 2022");
    if (_MSC_VER >= 1920)
        return QLatin1String("MSVC 2019");
    if (_MSC_VER >= 1910)
        return QLatin1String("MSVC 2017");
    if (_MSC_VER >= 1900)
        return QLatin1String("MSVC 2015");
#endif
    return QLatin1String("<unknown compiler>");
}

/*!
    Returns a string with the IDE's name and version, in the form "\QC X.Y.Z".
    Use this for "Generated by" strings and similar tasks.
*/
QString ICore::versionString()
{
    QString ideVersionDescription;
    if (QLatin1String(Constants::IDE_VERSION_LONG) != QLatin1String(Constants::IDE_VERSION_DISPLAY))
        ideVersionDescription = tr(" (%1)").arg(QLatin1String(Constants::IDE_VERSION_LONG));
    return tr("%1 %2%3").arg(QLatin1String(Constants::IDE_DISPLAY_NAME),
                             QLatin1String(Constants::IDE_VERSION_DISPLAY),
                             ideVersionDescription);
}

/*!
    \internal
*/
QString ICore::buildCompatibilityString()
{
    return tr("Based on Qt %1 (%2, %3)").arg(QLatin1String(qVersion()),
                                                 compilerString(),
                                                 QSysInfo::buildCpuArchitecture());
}

/*!
    Returns the top level IContext of the current context, or \c nullptr if
    there is none.

    \sa updateAdditionalContexts()
    \sa addContextObject()
    \sa {The Action Manager and Commands}
*/
IContext *ICore::currentContextObject()
{
    return m_mainwindow->currentContextObject();
}

/*!
    Returns the widget of the top level IContext of the current context, or \c
    nullptr if there is none.

    \sa currentContextObject()
*/
QWidget *ICore::currentContextWidget()
{
    IContext *context = currentContextObject();
    return context ? context->widget() : nullptr;
}

/*!
    Returns the registered IContext instance for the specified \a widget,
    if any.
*/
IContext *ICore::contextObject(QWidget *widget)
{
    return m_mainwindow->contextObject(widget);
}

/*!
    Returns the main window of the application.

    For dialog parents use dialogParent().

    \sa dialogParent()
*/
QMainWindow *ICore::mainWindow()
{
    return m_mainwindow;
}

/*!
    Returns a widget pointer suitable to use as parent for QDialogs.
*/
QWidget *ICore::dialogParent()
{
    QWidget *active = QApplication::activeModalWidget();
    if (!active)
        active = QApplication::activeWindow();
    if (!active || (active && active->windowFlags().testAnyFlags(Qt::SplashScreen | Qt::Popup)))
        active = m_mainwindow;
    return active;
}

/*!
    \internal
*/
QStatusBar *ICore::statusBar()
{
    return m_mainwindow->statusBar();
}

/*!
    Returns a central InfoBar that is shown in \QC's main window.
    Use for notifying the user of something without interrupting with
    dialog. Use sparingly.
*/
Utils::InfoBar *ICore::infoBar()
{
    return m_mainwindow->infoBar();
}

/*!
    Raises and activates the window for \a widget. This contains workarounds
    for X11.
*/
void ICore::raiseWindow(QWidget *widget)
{
    if (!widget)
        return;
    QWidget *window = widget->window();
    if (!window)
        return;
    if (window == m_mainwindow) {
        m_mainwindow->raiseWindow();
    } else {
        window->raise();
        window->activateWindow();
    }
}

/*!
    Removes the contexts specified by \a remove from the list of active
    additional contexts, and adds the contexts specified by \a add with \a
    priority.

    The additional contexts are not associated with an IContext instance.

    High priority additional contexts have higher priority than the contexts
    added by IContext instances, low priority additional contexts have lower
    priority than the contexts added by IContext instances.

    \sa addContextObject()
    \sa {The Action Manager and Commands}
*/
void ICore::updateAdditionalContexts(const Context &remove, const Context &add,
                                     ContextPriority priority)
{
    m_mainwindow->updateAdditionalContexts(remove, add, priority);
}

/*!
    Adds \a context with \a priority to the list of active additional contexts.

    \sa updateAdditionalContexts()
*/
void ICore::addAdditionalContext(const Context &context, ContextPriority priority)
{
    m_mainwindow->updateAdditionalContexts(Context(), context, priority);
}

/*!
    Removes \a context from the list of active additional contexts.

    \sa updateAdditionalContexts()
*/
void ICore::removeAdditionalContext(const Context &context)
{
    m_mainwindow->updateAdditionalContexts(context, Context(), ContextPriority::Low);
}

/*!
    Adds \a context to the list of registered IContext instances.
    Whenever the IContext's \l{IContext::widget()}{widget} is in the application
    focus widget's parent hierarchy, its \l{IContext::context()}{context} is
    added to the list of active contexts.

    \sa removeContextObject()
    \sa updateAdditionalContexts()
    \sa currentContextObject()
    \sa {The Action Manager and Commands}
*/
void ICore::addContextObject(IContext *context)
{
    m_mainwindow->addContextObject(context);
}

/*!
    Unregisters a \a context object from the list of registered IContext
    instances. IContext instances are automatically removed when they are
    deleted.

    \sa addContextObject()
    \sa updateAdditionalContexts()
    \sa currentContextObject()
*/
void ICore::removeContextObject(IContext *context)
{
    m_mainwindow->removeContextObject(context);
}

/*!
    Registers a \a window with the specified \a context. Registered windows are
    shown in the \uicontrol Window menu and get registered for the various
    window related actions, like the minimize, zoom, fullscreen and close
    actions.

    Whenever the application focus is in \a window, its \a context is made
    active.
*/
void ICore::registerWindow(QWidget *window, const Context &context)
{
    new WindowSupport(window, context); // deletes itself when widget is destroyed
}

void ICore::restartTrimmer()
{
    m_mainwindow->restartTrimmer();
}

/*!
    Opens files using \a filePaths and \a flags like it would be
    done if they were given to \QC on the command line, or
    they were opened via \uicontrol File > \uicontrol Open.
*/

void ICore::openFiles(const FilePaths &filePaths, ICore::OpenFilesFlags flags)
{
    MainWindow::openFiles(filePaths, flags);
}

/*!
    Provides a hook for plugins to veto on closing the application.

    When the application window requests a close, all listeners are called. If
    one of the \a listener calls returns \c false, the process is aborted and
    the event is ignored. If all calls return \c true, coreAboutToClose()
    is emitted and the event is accepted or performed.
*/
void ICore::addPreCloseListener(const std::function<bool ()> &listener)
{
    m_mainwindow->addPreCloseListener(listener);
}

/*!
    \internal
*/
QString ICore::systemInformation()
{
    QString result = PluginManager::systemInformation() + '\n';
    result += versionString() + '\n';
    result += buildCompatibilityString() + '\n';
#ifdef IDE_REVISION
    result += QString("From revision %1\n").arg(QString::fromLatin1(Constants::IDE_REVISION_STR).left(10));
#endif
#ifdef QTC_SHOW_BUILD_DATE
     result += QString("Built on %1 %2\n").arg(QLatin1String(__DATE__), QLatin1String(__TIME__));
#endif
     return result;
}

static const QString &screenShotsPath()
{
    static const QString path = qtcEnvironmentVariable("QTC_SCREENSHOTS_PATH");
    return path;
}

class ScreenShooter : public QObject
{
public:
    ScreenShooter(QWidget *widget, const QString &name, const QRect &rc)
        : m_widget(widget), m_name(name), m_rc(rc)
    {
        m_widget->installEventFilter(this);
    }

    bool eventFilter(QObject *watched, QEvent *event) override
    {
        QTC_ASSERT(watched == m_widget, return false);
        if (event->type() == QEvent::Show)
            QMetaObject::invokeMethod(this, &ScreenShooter::helper, Qt::QueuedConnection);
        return false;
    }

    void helper()
    {
        if (m_widget) {
            QRect rc = m_rc.isValid() ? m_rc : m_widget->rect();
            QPixmap pm = m_widget->grab(rc);
            for (int i = 0; ; ++i) {
                QString fileName = screenShotsPath() + '/' + m_name + QString("-%1.png").arg(i);
                if (!QFileInfo::exists(fileName)) {
                    pm.save(fileName);
                    break;
                }
            }
        }
        deleteLater();
    }

    QPointer<QWidget> m_widget;
    QString m_name;
    QRect m_rc;
};

/*!
    \internal
*/
void ICore::setupScreenShooter(const QString &name, QWidget *w, const QRect &rc)
{
    if (!screenShotsPath().isEmpty())
        new ScreenShooter(w, name, rc);
}

/*!
    Restarts \QC and restores the last session.
*/
void ICore::restart()
{
    m_mainwindow->restart();
}

/*!
    \internal
*/
void ICore::saveSettings(SaveSettingsReason reason)
{
    emit m_instance->saveSettingsRequested(reason);
    m_mainwindow->saveSettings();

    ICore::settings(QSettings::SystemScope)->sync();
    ICore::settings(QSettings::UserScope)->sync();
}

/*!
    \internal
*/
QStringList ICore::additionalAboutInformation()
{
    return m_mainwindow->additionalAboutInformation();
}

/*!
    \internal
*/
void ICore::appendAboutInformation(const QString &line)
{
    m_mainwindow->appendAboutInformation(line);
}

void ICore::updateNewItemDialogState()
{
    static bool wasRunning = false;
    static QWidget *previousDialog = nullptr;
    if (wasRunning == isNewItemDialogRunning() && previousDialog == newItemDialog())
        return;
    wasRunning = isNewItemDialogRunning();
    previousDialog = newItemDialog();
    emit instance()->newItemDialogStateChanged();
}

/*!
    \internal
*/
void ICore::setNewDialogFactory(const std::function<NewDialog *(QWidget *)> &newFactory)
{
    m_newDialogFactory = newFactory;
}

} // namespace Core
