/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt Creator.
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 as published by the Free Software
** Foundation with exceptions as appearing in the file LICENSE.GPL3-EXCEPT
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
****************************************************************************/

#include "pluginmanager.h"
#include "pluginmanager_p.h"
#include "pluginspec.h"
#include "pluginspec_p.h"
#include "optionsparser.h"
#include "iplugin.h"

#include <QCoreApplication>
#include <QCryptographicHash>
#include <QDateTime>
#include <QDebug>
#include <QDir>
#include <QEventLoop>
#include <QFile>
#include <QGuiApplication>
#include <QLibrary>
#include <QLibraryInfo>
#include <QMessageBox>
#include <QMetaProperty>
#include <QPushButton>
#include <QSysInfo>
#include <QTextStream>
#include <QTimer>
#include <QWriteLocker>

#include <utils/algorithm.h>
#include <utils/benchmarker.h>
#include <utils/executeondestruction.h>
#include <utils/fileutils.h>
#include <utils/hostosinfo.h>
#include <utils/mimeutils.h>
#include <utils/qtcassert.h>
#include <utils/qtcprocess.h>
#include <utils/qtcsettings.h>

#ifdef WITH_TESTS
#include <utils/hostosinfo.h>
#include <QTest>
#include <QThread>
#endif

#include <functional>
#include <memory>

Q_LOGGING_CATEGORY(pluginLog, "qtc.extensionsystem", QtWarningMsg)

const char C_IGNORED_PLUGINS[] = "Plugins/Ignored";
const char C_FORCEENABLED_PLUGINS[] = "Plugins/ForceEnabled";
const int DELAYED_INITIALIZE_INTERVAL = 20; // ms

enum { debugLeaks = 0 };

/*!
    \namespace ExtensionSystem
    \inmodule QtCreator
    \brief The ExtensionSystem namespace provides classes that belong to the
           core plugin system.

    The basic extension system contains the plugin manager and its supporting classes,
    and the IPlugin interface that must be implemented by plugin providers.
*/

/*!
    \namespace ExtensionSystem::Internal
    \internal
*/

/*!
    \class ExtensionSystem::PluginManager
    \inheaderfile extensionsystem/pluginmanager.h
    \inmodule QtCreator
    \ingroup mainclasses

    \brief The PluginManager class implements the core plugin system that
    manages the plugins, their life cycle, and their registered objects.

    The plugin manager is used for the following tasks:
    \list
    \li Manage plugins and their state
    \li Manipulate a \e {common object pool}
    \endlist

    \section1 Plugins
    Plugins must derive from the IPlugin class and have the IID
    \c "org.qt-project.Qt.QtCreatorPlugin".

    The plugin manager is used to set a list of file system directories to search for
    plugins, retrieve information about the state of these plugins, and to load them.

    Usually, the application creates a PluginManager instance and initiates the
    loading.
    \code
        // 'plugins' and subdirs will be searched for plugins
        PluginManager::setPluginPaths(QStringList("plugins"));
        PluginManager::loadPlugins(); // try to load all the plugins
    \endcode
    Additionally, it is possible to directly access plugin meta data, instances,
    and state.

    \section1 Object Pool
    Plugins (and everybody else) can add objects to a common \e pool that is located in
    the plugin manager. Objects in the pool must derive from QObject, there are no other
    prerequisites. Objects can be retrieved from the object pool via the getObject()
    and getObjectByName() functions.

    Whenever the state of the object pool changes, a corresponding signal is
    emitted by the plugin manager.

    A common usecase for the object pool is that a plugin (or the application) provides
    an \e {extension point} for other plugins, which is a class or interface that can
    be implemented and added to the object pool. The plugin that provides the
    extension point looks for implementations of the class or interface in the object pool.
    \code
        // Plugin A provides a "MimeTypeHandler" extension point
        // in plugin B:
        MyMimeTypeHandler *handler = new MyMimeTypeHandler();
        PluginManager::instance()->addObject(handler);
        // In plugin A:
        MimeTypeHandler *mimeHandler =
            PluginManager::getObject<MimeTypeHandler>();
    \endcode


    The ExtensionSystem::Invoker class template provides \e {syntactic sugar}
    for using \e soft extension points that may or may not be provided by an
    object in the pool. This approach neither requires the \e user plugin being
    linked against the \e provider plugin nor a common shared
    header file. The exposed interface is implicitly given by the
    invokable functions of the provider object in the object pool.

    The ExtensionSystem::invoke() function template encapsulates
    ExtensionSystem::Invoker construction for the common case where
    the success of the call is not checked.

    \code
        // In the "provide" plugin A:
        namespace PluginA {
        class SomeProvider : public QObject
        {
            Q_OBJECT

        public:
            Q_INVOKABLE QString doit(const QString &msg, int n) {
            {
                qDebug() << "I AM DOING IT " << msg;
                return QString::number(n);
            }
        };
        } // namespace PluginA


        // In the "user" plugin B:
        int someFuntionUsingPluginA()
        {
            using namespace ExtensionSystem;

            QObject *target = PluginManager::getObjectByClassName("PluginA::SomeProvider");

            if (target) {
                // Some random argument.
                QString msg = "REALLY.";

                // Plain function call, no return value.
                invoke<void>(target, "doit", msg, 2);

                // Plain function with no return value.
                qDebug() << "Result: " << invoke<QString>(target, "doit", msg, 21);

                // Record success of function call with return value.
                Invoker<QString> in1(target, "doit", msg, 21);
                qDebug() << "Success: (expected)" << in1.wasSuccessful();

                // Try to invoke a non-existing function.
                Invoker<QString> in2(target, "doitWrong", msg, 22);
                qDebug() << "Success (not expected):" << in2.wasSuccessful();

            } else {

                // We have to cope with plugin A's absence.
            }
        };
    \endcode

    \note The type of the parameters passed to the \c{invoke()} calls
    is deduced from the parameters themselves and must match the type of
    the arguments of the called functions \e{exactly}. No conversion or even
    integer promotions are applicable, so to invoke a function with a \c{long}
    parameter explicitly, use \c{long(43)} or such.

    \note The object pool manipulating functions are thread-safe.
*/

/*!
    \fn template <typename T> *ExtensionSystem::PluginManager::getObject()

    Retrieves the object of a given type from the object pool.

    This function uses \c qobject_cast to determine the type of an object.
    If there are more than one objects of the given type in
    the object pool, this function will arbitrarily choose one of them.

    \sa addObject()
*/

/*!
    \fn template <typename T, typename Predicate> *ExtensionSystem::PluginManager::getObject(Predicate predicate)

    Retrieves the object of a given type from the object pool that matches
    the \a predicate.

    This function uses \c qobject_cast to determine the type of an object.
    The predicate must be a function taking T * and returning a bool.
    If there is more than one object matching the type and predicate,
    this function will arbitrarily choose one of them.

    \sa addObject()
*/


using namespace Utils;

namespace ExtensionSystem {

using namespace Internal;

static Internal::PluginManagerPrivate *d = nullptr;
static PluginManager *m_instance = nullptr;

/*!
    Gets the unique plugin manager instance.
*/
PluginManager *PluginManager::instance()
{
    return m_instance;
}

/*!
    Creates a plugin manager. Should be done only once per application.
*/
PluginManager::PluginManager()
{
    m_instance = this;
    d = new PluginManagerPrivate(this);
}

/*!
    \internal
*/
PluginManager::~PluginManager()
{
    delete d;
    d = nullptr;
}

/*!
    Adds the object \a obj to the object pool, so it can be retrieved
    again from the pool by type.

    The plugin manager does not do any memory management. Added objects
    must be removed from the pool and deleted manually by whoever is responsible for the object.

    Emits the \c objectAdded() signal.

    \sa PluginManager::removeObject()
    \sa PluginManager::getObject()
    \sa PluginManager::getObjectByName()
*/
void PluginManager::addObject(QObject *obj)
{
    d->addObject(obj);
}

/*!
    Emits the \c aboutToRemoveObject() signal and removes the object \a obj
    from the object pool.
    \sa PluginManager::addObject()
*/
void PluginManager::removeObject(QObject *obj)
{
    d->removeObject(obj);
}

/*!
    Retrieves the list of all objects in the pool, unfiltered.

    Usually, clients do not need to call this function.

    \sa PluginManager::getObject()
*/
QVector<QObject *> PluginManager::allObjects()
{
    return d->allObjects;
}

/*!
    \internal
*/
QReadWriteLock *PluginManager::listLock()
{
    return &d->m_lock;
}

/*!
    Tries to load all the plugins that were previously found when
    setting the plugin search paths. The plugin specs of the plugins
    can be used to retrieve error and state information about individual plugins.

    \sa setPluginPaths()
    \sa plugins()
*/
void PluginManager::loadPlugins()
{
    d->loadPlugins();
}

/*!
    Returns \c true if any plugin has errors even though it is enabled.
    Most useful to call after loadPlugins().
*/
bool PluginManager::hasError()
{
    return Utils::anyOf(plugins(), [](PluginSpec *spec) {
        // only show errors on startup if plugin is enabled.
        return spec->hasError() && spec->isEffectivelyEnabled();
    });
}

const QStringList PluginManager::allErrors()
{
    return Utils::transform<QStringList>(Utils::filtered(plugins(), [](const PluginSpec *spec) {
        return spec->hasError() && spec->isEffectivelyEnabled();
    }), [](const PluginSpec *spec) {
        return spec->name().append(": ").append(spec->errorString());
    });
}

/*!
    Returns all plugins that require \a spec to be loaded. Recurses into dependencies.
 */
const QSet<PluginSpec *> PluginManager::pluginsRequiringPlugin(PluginSpec *spec)
{
    QSet<PluginSpec *> dependingPlugins({spec});
    // recursively add plugins that depend on plugins that.... that depend on spec
    for (PluginSpec *spec : d->loadQueue()) {
        if (spec->requiresAny(dependingPlugins))
            dependingPlugins.insert(spec);
    }
    dependingPlugins.remove(spec);
    return dependingPlugins;
}

/*!
    Returns all plugins that \a spec requires to be loaded. Recurses into dependencies.
 */
const QSet<PluginSpec *> PluginManager::pluginsRequiredByPlugin(PluginSpec *spec)
{
    QSet<PluginSpec *> recursiveDependencies;
    recursiveDependencies.insert(spec);
    std::queue<PluginSpec *> queue;
    queue.push(spec);
    while (!queue.empty()) {
        PluginSpec *checkSpec = queue.front();
        queue.pop();
        const QHash<PluginDependency, PluginSpec *> deps = checkSpec->dependencySpecs();
        for (auto depIt = deps.cbegin(), end = deps.cend(); depIt != end; ++depIt) {
            if (depIt.key().type != PluginDependency::Required)
                continue;
            PluginSpec *depSpec = depIt.value();
            if (!recursiveDependencies.contains(depSpec)) {
                recursiveDependencies.insert(depSpec);
                queue.push(depSpec);
            }
        }
    }
    recursiveDependencies.remove(spec);
    return recursiveDependencies;
}

/*!
    Shuts down and deletes all plugins.
*/
void PluginManager::shutdown()
{
    d->shutdown();
}

static QString filled(const QString &s, int min)
{
    return s + QString(qMax(0, min - s.size()), ' ');
}

QString PluginManager::systemInformation()
{
    QString result;
    CommandLine qtDiag(FilePath::fromString(QLibraryInfo::location(QLibraryInfo::BinariesPath))
                        .pathAppended("qtdiag").withExecutableSuffix());
    QtcProcess qtDiagProc;
    qtDiagProc.setCommand(qtDiag);
    qtDiagProc.runBlocking();
    if (qtDiagProc.result() == ProcessResult::FinishedWithSuccess)
        result += qtDiagProc.allOutput() + "\n";
    result += "Plugin information:\n\n";
    auto longestSpec = std::max_element(d->pluginSpecs.cbegin(), d->pluginSpecs.cend(),
                                        [](const PluginSpec *left, const PluginSpec *right) {
                                            return left->name().size() < right->name().size();
                                        });
    int size = (*longestSpec)->name().size();
    for (const PluginSpec *spec : plugins()) {
        result += QLatin1String(spec->isEffectivelyEnabled() ? "+ " : "  ") + filled(spec->name(), size) +
                  " " + spec->version() + "\n";
    }
    QString settingspath = QFileInfo(settings()->fileName()).path();
    if (settingspath.startsWith(QDir::homePath()))
        settingspath.replace(QDir::homePath(), "~");
    result += "\nUsed settingspath: " + settingspath + "\n";
    return result;
}

/*!
    The list of paths were the plugin manager searches for plugins.

    \sa setPluginPaths()
*/
QStringList PluginManager::pluginPaths()
{
    return d->pluginPaths;
}

/*!
    Sets the plugin paths. All the specified \a paths and their subdirectory
    trees are searched for plugins.

    \sa pluginPaths()
    \sa loadPlugins()
*/
void PluginManager::setPluginPaths(const QStringList &paths)
{
    d->setPluginPaths(paths);
}

/*!
    The IID that valid plugins must have.

    \sa setPluginIID()
*/
QString PluginManager::pluginIID()
{
    return d->pluginIID;
}

/*!
    Sets the IID that valid plugins must have to \a iid. Only plugins with this
    IID are loaded, others are silently ignored.

    At the moment this must be called before setPluginPaths() is called.

    \omit
    // ### TODO let this + setPluginPaths read the plugin meta data lazyly whenever loadPlugins() or plugins() is called.
    \endomit
*/
void PluginManager::setPluginIID(const QString &iid)
{
    d->pluginIID = iid;
}

/*!
    Defines the user specific \a settings to use for information about enabled and
    disabled plugins.
    Needs to be set before the plugin search path is set with setPluginPaths().
*/
void PluginManager::setSettings(QtcSettings *settings)
{
    d->setSettings(settings);
}

/*!
    Defines the global (user-independent) \a settings to use for information about
    default disabled plugins.
    Needs to be set before the plugin search path is set with setPluginPaths().
*/
void PluginManager::setGlobalSettings(QtcSettings *settings)
{
    d->setGlobalSettings(settings);
}

/*!
    Returns the user specific settings used for information about enabled and
    disabled plugins.
*/
QtcSettings *PluginManager::settings()
{
    return d->settings;
}

/*!
    Returns the global (user-independent) settings used for information about default disabled plugins.
*/
QtcSettings *PluginManager::globalSettings()
{
    return d->globalSettings;
}

void PluginManager::writeSettings()
{
    d->writeSettings();
}

/*!
    The arguments left over after parsing (that were neither startup nor plugin
    arguments). Typically, this will be the list of files to open.
*/
QStringList PluginManager::arguments()
{
    return d->arguments;
}

/*!
    The arguments that should be used when automatically restarting the application.
    This includes plugin manager related options for enabling or disabling plugins,
    but excludes others, like the arguments returned by arguments() and the appOptions
    passed to the parseOptions() method.
*/
QStringList PluginManager::argumentsForRestart()
{
    return d->argumentsForRestart;
}

/*!
    List of all plugins that have been found in the plugin search paths.
    This list is valid directly after the setPluginPaths() call.
    The plugin specifications contain plugin metadata and the current state
    of the plugins. If a plugin's library has been already successfully loaded,
    the plugin specification has a reference to the created plugin instance as well.

    \sa setPluginPaths()
*/
const QVector<PluginSpec *> PluginManager::plugins()
{
    return d->pluginSpecs;
}

QHash<QString, QVector<PluginSpec *>> PluginManager::pluginCollections()
{
    return d->pluginCategories;
}

static const char argumentKeywordC[] = ":arguments";
static const char pwdKeywordC[] = ":pwd";

/*!
    Serializes plugin options and arguments for sending in a single string
    via QtSingleApplication:
    ":myplugin|-option1|-option2|:arguments|argument1|argument2",
    as a list of lists started by a keyword with a colon. Arguments are last.

    \sa setPluginPaths()
*/
QString PluginManager::serializedArguments()
{
    const QChar separator = QLatin1Char('|');
    QString rc;
    for (const PluginSpec *ps : plugins()) {
        if (!ps->arguments().isEmpty()) {
            if (!rc.isEmpty())
                rc += separator;
            rc += QLatin1Char(':');
            rc += ps->name();
            rc += separator;
            rc +=  ps->arguments().join(separator);
        }
    }
    if (!rc.isEmpty())
        rc += separator;
    rc += QLatin1String(pwdKeywordC) + separator + QDir::currentPath();
    if (!d->arguments.isEmpty()) {
        if (!rc.isEmpty())
            rc += separator;
        rc += QLatin1String(argumentKeywordC);
        for (const QString &argument : qAsConst(d->arguments))
            rc += separator + argument;
    }
    return rc;
}

/* Extract a sublist from the serialized arguments
 * indicated by a keyword starting with a colon indicator:
 * ":a,i1,i2,:b:i3,i4" with ":a" -> "i1,i2"
 */
static QStringList subList(const QStringList &in, const QString &key)
{
    QStringList rc;
    // Find keyword and copy arguments until end or next keyword
    const QStringList::const_iterator inEnd = in.constEnd();
    QStringList::const_iterator it = std::find(in.constBegin(), inEnd, key);
    if (it != inEnd) {
        const QChar nextIndicator = QLatin1Char(':');
        for (++it; it != inEnd && !it->startsWith(nextIndicator); ++it)
            rc.append(*it);
    }
    return rc;
}

/*!
    Parses the options encoded in \a serializedArgument
    and passes them on to the respective plugins along with the arguments.

    \a socket is passed for disconnecting the peer when the operation is done (for example,
    document is closed) for supporting the \c -block flag.
*/

void PluginManager::remoteArguments(const QString &serializedArgument, QObject *socket)
{
    if (serializedArgument.isEmpty())
        return;
    QStringList serializedArguments = serializedArgument.split(QLatin1Char('|'));
    const QStringList pwdValue = subList(serializedArguments, QLatin1String(pwdKeywordC));
    const QString workingDirectory = pwdValue.isEmpty() ? QString() : pwdValue.first();
    const QStringList arguments = subList(serializedArguments, QLatin1String(argumentKeywordC));
    for (const PluginSpec *ps : plugins()) {
        if (ps->state() == PluginSpec::Running) {
            const QStringList pluginOptions = subList(serializedArguments, QLatin1Char(':') + ps->name());
            QObject *socketParent = ps->plugin()->remoteCommand(pluginOptions, workingDirectory,
                                                                arguments);
            if (socketParent && socket) {
                socket->setParent(socketParent);
                socket = nullptr;
            }
        }
    }
    if (socket)
        delete socket;
}

/*!
    Takes the list of command line options in \a args and parses them.
    The plugin manager itself might process some options itself directly
    (\c {-noload <plugin>}), and adds options that are registered by
    plugins to their plugin specs.

    The caller (the application) may register itself for options via the
    \a appOptions list, containing pairs of \e {option string} and a bool
    that indicates whether the option requires an argument.
    Application options always override any plugin's options.

    \a foundAppOptions is set to pairs of (\e {option string}, \e argument)
    for any application options that were found.
    The command line options that were not processed can be retrieved via the arguments() function.
    If an error occurred (like missing argument for an option that requires one), \a errorString contains
    a descriptive message of the error.

    Returns if there was an error.
 */
bool PluginManager::parseOptions(const QStringList &args,
    const QMap<QString, bool> &appOptions,
    QMap<QString, QString> *foundAppOptions,
    QString *errorString)
{
    OptionsParser options(args, appOptions, foundAppOptions, errorString, d);
    return options.parse();
}



static inline void indent(QTextStream &str, int indent)
{
    str << QString(indent, ' ');
}

static inline void formatOption(QTextStream &str,
                                const QString &opt, const QString &parm, const QString &description,
                                int optionIndentation, int descriptionIndentation)
{
    int remainingIndent = descriptionIndentation - optionIndentation - opt.size();
    indent(str, optionIndentation);
    str << opt;
    if (!parm.isEmpty()) {
        str << " <" << parm << '>';
        remainingIndent -= 3 + parm.size();
    }
    if (remainingIndent >= 1) {
        indent(str, remainingIndent);
    } else {
        str << '\n';
        indent(str, descriptionIndentation);
    }
    str << description << '\n';
}

/*!
    Formats the startup options of the plugin manager for command line help with the specified
    \a optionIndentation and \a descriptionIndentation.
    Adds the result to \a str.
*/

void PluginManager::formatOptions(QTextStream &str, int optionIndentation, int descriptionIndentation)
{
    formatOption(str, QLatin1String(OptionsParser::LOAD_OPTION),
                 QLatin1String("plugin"), QLatin1String("Load <plugin> and all plugins that it requires"),
                 optionIndentation, descriptionIndentation);
    formatOption(str, QLatin1String(OptionsParser::LOAD_OPTION) + QLatin1String(" all"),
                 QString(), QLatin1String("Load all available plugins"),
                 optionIndentation, descriptionIndentation);
    formatOption(str, QLatin1String(OptionsParser::NO_LOAD_OPTION),
                 QLatin1String("plugin"), QLatin1String("Do not load <plugin> and all plugins that require it"),
                 optionIndentation, descriptionIndentation);
    formatOption(str, QLatin1String(OptionsParser::NO_LOAD_OPTION) + QLatin1String(" all"),
                 QString(), QString::fromLatin1("Do not load any plugin (useful when "
                                                "followed by one or more \"%1\" arguments)")
                 .arg(QLatin1String(OptionsParser::LOAD_OPTION)),
                 optionIndentation, descriptionIndentation);
    formatOption(str, QLatin1String(OptionsParser::PROFILE_OPTION),
                 QString(), QLatin1String("Profile plugin loading"),
                 optionIndentation, descriptionIndentation);
    formatOption(str,
                 QLatin1String(OptionsParser::NO_CRASHCHECK_OPTION),
                 QString(),
                 QLatin1String("Disable startup check for previously crashed instance"),
                 optionIndentation,
                 descriptionIndentation);
#ifdef WITH_TESTS
    formatOption(str, QString::fromLatin1(OptionsParser::TEST_OPTION)
                 + QLatin1String(" <plugin>[,testfunction[:testdata]]..."), QString(),
                 QLatin1String("Run plugin's tests (by default a separate settings path is used)"),
                 optionIndentation, descriptionIndentation);
    formatOption(str, QString::fromLatin1(OptionsParser::TEST_OPTION) + QLatin1String(" all"),
                 QString(), QLatin1String("Run tests from all plugins"),
                 optionIndentation, descriptionIndentation);
    formatOption(str, QString::fromLatin1(OptionsParser::NOTEST_OPTION),
                 QLatin1String("plugin"), QLatin1String("Exclude all of the plugin's tests from the test run"),
                 optionIndentation, descriptionIndentation);
    formatOption(str, QString::fromLatin1(OptionsParser::SCENARIO_OPTION),
                 QString("scenarioname"), QLatin1String("Run given scenario"),
                 optionIndentation, descriptionIndentation);
#endif
}

/*!
    Formats the plugin options of the plugin specs for command line help with the specified
    \a optionIndentation and \a descriptionIndentation.
    Adds the result to \a str.
*/

void PluginManager::formatPluginOptions(QTextStream &str, int optionIndentation, int descriptionIndentation)
{
    // Check plugins for options
    for (PluginSpec *ps : qAsConst(d->pluginSpecs)) {
        const PluginSpec::PluginArgumentDescriptions pargs = ps->argumentDescriptions();
        if (!pargs.empty()) {
            str << "\nPlugin: " <<  ps->name() << '\n';
            for (const PluginArgumentDescription &pad : pargs)
                formatOption(str, pad.name, pad.parameter, pad.description, optionIndentation, descriptionIndentation);
        }
    }
}

/*!
    Formats the version of the plugin specs for command line help and adds it to \a str.
*/
void PluginManager::formatPluginVersions(QTextStream &str)
{
    for (PluginSpec *ps : qAsConst(d->pluginSpecs))
        str << "  " << ps->name() << ' ' << ps->version() << ' ' << ps->description() <<  '\n';
}

/*!
    \internal
 */
bool PluginManager::testRunRequested()
{
    return !d->testSpecs.empty();
}

#ifdef WITH_TESTS
// Called in plugin initialization, the scenario function will be called later, from main
bool PluginManager::registerScenario(const QString &scenarioId, std::function<bool()> scenarioStarter)
{
    if (d->m_scenarios.contains(scenarioId)) {
        const QString warning = QString("Can't register scenario \"%1\" as the other scenario was "
                    "already registered with this name.").arg(scenarioId);
        qWarning("%s", qPrintable(warning));
        return false;
    }

    d->m_scenarios.insert(scenarioId, scenarioStarter);
    return true;
}

// Called from main
bool PluginManager::isScenarioRequested()
{
    return !d->m_requestedScenario.isEmpty();
}

// Called from main (may be squashed with the isScenarioRequested: runScenarioIfRequested).
// Returns false if scenario couldn't run (e.g. no Qt version set)
bool PluginManager::runScenario()
{
    if (d->m_isScenarioRunning) {
        qWarning("Scenario is already running. Can't run scenario recursively.");
        return false;
    }

    if (d->m_requestedScenario.isEmpty()) {
        qWarning("Can't run any scenario since no scenario was requested.");
        return false;
    }

    if (!d->m_scenarios.contains(d->m_requestedScenario)) {
        const QString warning = QString("Requested scenario \"%1\" was not registered.").arg(d->m_requestedScenario);
        qWarning("%s", qPrintable(warning));
        return false;
    }

    d->m_isScenarioRunning = true;
    // The return value comes now from scenarioStarted() function. It may fail e.g. when
    // no Qt version is set. Initializing the scenario may take some time, that's why
    // waitForScenarioFullyInitialized() was added.
    bool ret = d->m_scenarios[d->m_requestedScenario]();

    QMutexLocker locker(&d->m_scenarioMutex);
    d->m_scenarioFullyInitialized = true;
    d->m_scenarioWaitCondition.wakeAll();

    return ret;
}

// Called from scenario point (and also from runScenario - don't run scenarios recursively).
// This may be called from non-main thread. We assume that m_requestedScenario
// may only be changed from the main thread.
bool PluginManager::isScenarioRunning(const QString &scenarioId)
{
    return d->m_isScenarioRunning && d->m_requestedScenario == scenarioId;
}

// This may be called from non-main thread.
bool PluginManager::finishScenario()
{
    if (!d->m_isScenarioRunning)
        return false; // Can't finish not running scenario

    if (d->m_isScenarioFinished.exchange(true))
        return false; // Finish was already called before. We return false, as we didn't finish it right now.

    QMetaObject::invokeMethod(d, []() { emit m_instance->scenarioFinished(0); });
    return true; // Finished successfully.
}

// Waits until the running scenario is fully initialized
void PluginManager::waitForScenarioFullyInitialized()
{
    if (QThread::currentThread() == qApp->thread()) {
        qWarning("The waitForScenarioFullyInitialized() function can't be called from main thread.");
        return;
    }
    QMutexLocker locker(&d->m_scenarioMutex);
    if (d->m_scenarioFullyInitialized)
        return;

    d->m_scenarioWaitCondition.wait(&d->m_scenarioMutex);
}
#endif

void PluginManager::setCreatorProcessData(const PluginManager::ProcessData &data)
{
    d->m_creatorProcessData = data;
}

PluginManager::ProcessData PluginManager::creatorProcessData()
{
    return d->m_creatorProcessData;
}

/*!
    \internal
*/

void PluginManager::profilingReport(const char *what, const PluginSpec *spec)
{
    d->profilingReport(what, spec);
}


/*!
    Returns a list of plugins in load order.
*/
QVector<PluginSpec *> PluginManager::loadQueue()
{
    return d->loadQueue();
}

//============PluginManagerPrivate===========

/*!
    \internal
*/
PluginSpec *PluginManagerPrivate::createSpec()
{
    return new PluginSpec();
}

/*!
    \internal
*/
void PluginManagerPrivate::setSettings(QtcSettings *s)
{
    if (settings)
        delete settings;
    settings = s;
    if (settings)
        settings->setParent(this);
}

/*!
    \internal
*/
void PluginManagerPrivate::setGlobalSettings(QtcSettings *s)
{
    if (globalSettings)
        delete globalSettings;
    globalSettings = s;
    if (globalSettings)
        globalSettings->setParent(this);
}

/*!
    \internal
*/
PluginSpecPrivate *PluginManagerPrivate::privateSpec(PluginSpec *spec)
{
    return spec->d;
}

void PluginManagerPrivate::nextDelayedInitialize()
{
    while (!delayedInitializeQueue.empty()) {
        PluginSpec *spec = delayedInitializeQueue.front();
        delayedInitializeQueue.pop();
        profilingReport(">delayedInitialize", spec);
        bool delay = spec->d->delayedInitialize();
        profilingReport("<delayedInitialize", spec);
        if (delay)
            break; // do next delayedInitialize after a delay
    }
    if (delayedInitializeQueue.empty()) {
        m_isInitializationDone = true;
        delete delayedInitializeTimer;
        delayedInitializeTimer = nullptr;
        profilingSummary();
        emit q->initializationDone();
#ifdef WITH_TESTS
        if (PluginManager::testRunRequested())
            startTests();
        else if (PluginManager::isScenarioRequested()) {
            if (PluginManager::runScenario()) {
                const QString info = QString("Successfully started scenario \"%1\"...").arg(d->m_requestedScenario);
                qInfo("%s", qPrintable(info));
            } else {
                QMetaObject::invokeMethod(this, []() { emit m_instance->scenarioFinished(1); });
            }
        }
#endif
    } else {
        delayedInitializeTimer->start();
    }
}

/*!
    \internal
*/
PluginManagerPrivate::PluginManagerPrivate(PluginManager *pluginManager) :
    q(pluginManager)
{
}


/*!
    \internal
*/
PluginManagerPrivate::~PluginManagerPrivate()
{
    qDeleteAll(pluginSpecs);
}

/*!
    \internal
*/
void PluginManagerPrivate::writeSettings()
{
    if (!settings)
        return;
    QStringList tempDisabledPlugins;
    QStringList tempForceEnabledPlugins;
    for (PluginSpec *spec : qAsConst(pluginSpecs)) {
        if (spec->isEnabledByDefault() && !spec->isEnabledBySettings())
            tempDisabledPlugins.append(spec->name());
        if (!spec->isEnabledByDefault() && spec->isEnabledBySettings())
            tempForceEnabledPlugins.append(spec->name());
    }

    settings->setValueWithDefault(C_IGNORED_PLUGINS, tempDisabledPlugins);
    settings->setValueWithDefault(C_FORCEENABLED_PLUGINS, tempForceEnabledPlugins);
}

/*!
    \internal
*/
void PluginManagerPrivate::readSettings()
{
    if (globalSettings) {
        defaultDisabledPlugins = globalSettings->value(QLatin1String(C_IGNORED_PLUGINS)).toStringList();
        defaultEnabledPlugins = globalSettings->value(QLatin1String(C_FORCEENABLED_PLUGINS)).toStringList();
    }
    if (settings) {
        disabledPlugins = settings->value(QLatin1String(C_IGNORED_PLUGINS)).toStringList();
        forceEnabledPlugins = settings->value(QLatin1String(C_FORCEENABLED_PLUGINS)).toStringList();
    }
}

/*!
    \internal
*/
void PluginManagerPrivate::stopAll()
{
    if (delayedInitializeTimer && delayedInitializeTimer->isActive()) {
        delayedInitializeTimer->stop();
        delete delayedInitializeTimer;
        delayedInitializeTimer = nullptr;
    }

    const QVector<PluginSpec *> queue = loadQueue();
    for (PluginSpec *spec : queue)
        loadPlugin(spec, PluginSpec::Stopped);
}

/*!
    \internal
*/
void PluginManagerPrivate::deleteAll()
{
    Utils::reverseForeach(loadQueue(), [this](PluginSpec *spec) {
        loadPlugin(spec, PluginSpec::Deleted);
    });
}

#ifdef WITH_TESTS

using TestPlan = QMap<QObject *, QStringList>; // Object -> selected test functions

static bool isTestFunction(const QMetaMethod &metaMethod)
{
    static const QVector<QByteArray> blackList = {"initTestCase()",
                                                  "cleanupTestCase()",
                                                  "init()",
                                                  "cleanup()"};

    if (metaMethod.methodType() != QMetaMethod::Slot)
        return false;

    if (metaMethod.access() != QMetaMethod::Private)
        return false;

    const QByteArray signature = metaMethod.methodSignature();
    if (blackList.contains(signature))
        return false;

    if (!signature.startsWith("test"))
        return false;

    if (signature.endsWith("_data()"))
        return false;

    return true;
}

static QStringList testFunctions(const QMetaObject *metaObject)
{

    QStringList functions;

    for (int i = metaObject->methodOffset(); i < metaObject->methodCount(); ++i) {
        const QMetaMethod metaMethod = metaObject->method(i);
        if (isTestFunction(metaMethod)) {
            const QByteArray signature = metaMethod.methodSignature();
            const QString method = QString::fromLatin1(signature);
            const QString methodName = method.left(method.size() - 2);
            functions.append(methodName);
        }
    }

    return functions;
}

static QStringList matchingTestFunctions(const QStringList &testFunctions,
                                         const QString &matchText)
{
    // There might be a test data suffix like in "testfunction:testdata1".
    QString testFunctionName = matchText;
    QString testDataSuffix;
    const int index = testFunctionName.indexOf(QLatin1Char(':'));
    if (index != -1) {
        testDataSuffix = testFunctionName.mid(index);
        testFunctionName = testFunctionName.left(index);
    }

    const QRegularExpression regExp(
                QRegularExpression::wildcardToRegularExpression(testFunctionName));
    QStringList matchingFunctions;
    for (const QString &testFunction : testFunctions) {
        if (regExp.match(testFunction).hasMatch()) {
            // If the specified test data is invalid, the QTest framework will
            // print a reasonable error message for us.
            matchingFunctions.append(testFunction + testDataSuffix);
        }
    }

    return matchingFunctions;
}

static QObject *objectWithClassName(const QVector<QObject *> &objects, const QString &className)
{
    return Utils::findOr(objects, nullptr, [className] (QObject *object) -> bool {
        QString candidate = QString::fromUtf8(object->metaObject()->className());
        const int colonIndex = candidate.lastIndexOf(QLatin1Char(':'));
        if (colonIndex != -1 && colonIndex < candidate.size() - 1)
            candidate = candidate.mid(colonIndex + 1);
        return candidate == className;
    });
}

static int executeTestPlan(const TestPlan &testPlan)
{
    int failedTests = 0;

    for (auto it = testPlan.cbegin(), end = testPlan.cend(); it != end; ++it) {
        QObject *testObject = it.key();
        QStringList functions = it.value();

        // Don't run QTest::qExec without any test functions, that'd run *all* slots as tests.
        if (functions.isEmpty())
            continue;

        functions.removeDuplicates();

        // QTest::qExec() expects basically QCoreApplication::arguments(),
        QStringList qExecArguments = QStringList()
                << QLatin1String("arg0") // fake application name
                << QLatin1String("-maxwarnings") << QLatin1String("0"); // unlimit output
        qExecArguments << functions;
        // avoid being stuck in QTBUG-24925
        if (!HostOsInfo::isWindowsHost())
            qExecArguments << "-nocrashhandler";
        failedTests += QTest::qExec(testObject, qExecArguments);
    }

    return failedTests;
}

/// Resulting plan consists of all test functions of the plugin object and
/// all test functions of all test objects of the plugin.
static TestPlan generateCompleteTestPlan(IPlugin *plugin, const QVector<QObject *> &testObjects)
{
    TestPlan testPlan;

    testPlan.insert(plugin, testFunctions(plugin->metaObject()));
    for (QObject *testObject : testObjects) {
        const QStringList allFunctions = testFunctions(testObject->metaObject());
        testPlan.insert(testObject, allFunctions);
    }

    return testPlan;
}

/// Resulting plan consists of all matching test functions of the plugin object
/// and all matching functions of all test objects of the plugin. However, if a
/// match text denotes a test class, all test functions of that will be
/// included and the class will not be considered further.
///
/// Since multiple match texts can match the same function, a test function might
/// be included multiple times for a test object.
static TestPlan generateCustomTestPlan(IPlugin *plugin,
                                       const QVector<QObject *> &testObjects,
                                       const QStringList &matchTexts)
{
    TestPlan testPlan;

    const QStringList testFunctionsOfPluginObject = testFunctions(plugin->metaObject());
    QStringList matchedTestFunctionsOfPluginObject;
    QStringList remainingMatchTexts = matchTexts;
    QVector<QObject *> remainingTestObjectsOfPlugin = testObjects;

    while (!remainingMatchTexts.isEmpty()) {
        const QString matchText = remainingMatchTexts.takeFirst();
        bool matched = false;

        if (QObject *testObject = objectWithClassName(remainingTestObjectsOfPlugin, matchText)) {
            // Add all functions of the matching test object
            matched = true;
            testPlan.insert(testObject, testFunctions(testObject->metaObject()));
            remainingTestObjectsOfPlugin.removeAll(testObject);

        } else {
            // Add all matching test functions of all remaining test objects
            for (QObject *testObject : qAsConst(remainingTestObjectsOfPlugin)) {
                const QStringList allFunctions = testFunctions(testObject->metaObject());
                const QStringList matchingFunctions = matchingTestFunctions(allFunctions,
                                                                            matchText);
                if (!matchingFunctions.isEmpty()) {
                    matched = true;
                    testPlan[testObject] += matchingFunctions;
                }
            }
        }

        const QStringList currentMatchedTestFunctionsOfPluginObject
            = matchingTestFunctions(testFunctionsOfPluginObject, matchText);
        if (!currentMatchedTestFunctionsOfPluginObject.isEmpty()) {
            matched = true;
            matchedTestFunctionsOfPluginObject += currentMatchedTestFunctionsOfPluginObject;
        }

        if (!matched) {
            QTextStream out(stdout);
            out << "No test function or class matches \"" << matchText
                << "\" in plugin \"" << plugin->metaObject()->className()
                << "\".\nAvailable functions:\n";
            for (const QString &f : testFunctionsOfPluginObject)
                out << "  " << f << '\n';
            out << '\n';
        }
    }

    // Add all matching test functions of plugin
    if (!matchedTestFunctionsOfPluginObject.isEmpty())
        testPlan.insert(plugin, matchedTestFunctionsOfPluginObject);

    return testPlan;
}

void PluginManagerPrivate::startTests()
{
    if (PluginManager::hasError()) {
        qWarning("Errors occurred while loading plugins, skipping test run.");
        for (const QString &pluginError : PluginManager::allErrors())
            qWarning("%s", qPrintable(pluginError));
        QTimer::singleShot(1, QCoreApplication::instance(), &QCoreApplication::quit);
        return;
    }

    int failedTests = 0;
    for (const TestSpec &testSpec : qAsConst(testSpecs)) {
        IPlugin *plugin = testSpec.pluginSpec->plugin();
        if (!plugin)
            continue; // plugin not loaded

        const QVector<QObject *> testObjects = plugin->createTestObjects();
        ExecuteOnDestruction deleteTestObjects([&]() { qDeleteAll(testObjects); });
        Q_UNUSED(deleteTestObjects)

        const bool hasDuplicateTestObjects = testObjects.size()
                                             != Utils::filteredUnique(testObjects).size();
        QTC_ASSERT(!hasDuplicateTestObjects, continue);
        QTC_ASSERT(!testObjects.contains(plugin), continue);

        const TestPlan testPlan = testSpec.testFunctionsOrObjects.isEmpty()
                ? generateCompleteTestPlan(plugin, testObjects)
                : generateCustomTestPlan(plugin, testObjects, testSpec.testFunctionsOrObjects);

        failedTests += executeTestPlan(testPlan);
    }

    QTimer::singleShot(0, this, [failedTests]() { emit m_instance->testsFinished(failedTests); });
}
#endif

/*!
    \internal
*/
void PluginManagerPrivate::addObject(QObject *obj)
{
    {
        QWriteLocker lock(&m_lock);
        if (obj == nullptr) {
            qWarning() << "PluginManagerPrivate::addObject(): trying to add null object";
            return;
        }
        if (allObjects.contains(obj)) {
            qWarning() << "PluginManagerPrivate::addObject(): trying to add duplicate object";
            return;
        }

        if (debugLeaks)
            qDebug() << "PluginManagerPrivate::addObject" << obj << obj->objectName();

        if (m_profilingVerbosity && !m_profileTimer.isNull()) {
            // Report a timestamp when adding an object. Useful for profiling
            // its initialization time.
            const int absoluteElapsedMS = int(m_profileTimer->elapsed());
            qDebug("  %-43s %8dms", obj->metaObject()->className(), absoluteElapsedMS);
        }

        allObjects.append(obj);
    }
    emit q->objectAdded(obj);
}

/*!
    \internal
*/
void PluginManagerPrivate::removeObject(QObject *obj)
{
    if (obj == nullptr) {
        qWarning() << "PluginManagerPrivate::removeObject(): trying to remove null object";
        return;
    }

    if (!allObjects.contains(obj)) {
        qWarning() << "PluginManagerPrivate::removeObject(): object not in list:"
            << obj << obj->objectName();
        return;
    }
    if (debugLeaks)
        qDebug() << "PluginManagerPrivate::removeObject" << obj << obj->objectName();

    emit q->aboutToRemoveObject(obj);
    QWriteLocker lock(&m_lock);
    allObjects.removeAll(obj);
}

/*!
    \internal
*/
void PluginManagerPrivate::loadPlugins()
{
    const QVector<PluginSpec *> queue = loadQueue();
    Utils::setMimeStartupPhase(MimeStartupPhase::PluginsLoading);
    for (PluginSpec *spec : queue) {
        qDebug() << "PluginManagerPrivate::loadPlugins spec" << spec << spec->name() << spec->version() << "data" << spec->d << "state" << spec->state() << "loadPlugin Loaded";
        loadPlugin(spec, PluginSpec::Loaded);
    }

    Utils::setMimeStartupPhase(MimeStartupPhase::PluginsInitializing);
    for (PluginSpec *spec : queue) {
        qDebug() << "PluginManagerPrivate::loadPlugins spec" << spec << spec->name() << spec->version() << "data" << spec->d << "state" << spec->state() << "loadPlugin Initialized";
        loadPlugin(spec, PluginSpec::Initialized);
    }

    // qt-creator-opensource-src-8.0.1/src/libs/extensionsystem/pluginspec.h
    // class PluginSpec {
    //   enum State { Invalid, Read, Resolved, Loaded, Initialized, Running, Stopped, Deleted };
    qDebug() << "PluginManagerPrivate::loadPlugins PluginSpec::Invalid" << PluginSpec::Invalid;
    qDebug() << "PluginManagerPrivate::loadPlugins PluginSpec::Read" << PluginSpec::Read;
    qDebug() << "PluginManagerPrivate::loadPlugins PluginSpec::Resolved" << PluginSpec::Resolved;
    qDebug() << "PluginManagerPrivate::loadPlugins PluginSpec::Loaded" << PluginSpec::Loaded;
    qDebug() << "PluginManagerPrivate::loadPlugins PluginSpec::Initialized" << PluginSpec::Initialized;
    qDebug() << "PluginManagerPrivate::loadPlugins PluginSpec::Running" << PluginSpec::Running;
    qDebug() << "PluginManagerPrivate::loadPlugins PluginSpec::Stopped" << PluginSpec::Stopped;
    qDebug() << "PluginManagerPrivate::loadPlugins PluginSpec::Deleted" << PluginSpec::Deleted;

    Utils::setMimeStartupPhase(MimeStartupPhase::PluginsDelayedInitializing);
    Utils::reverseForeach(queue, [this](PluginSpec *spec) {
        qDebug() << "PluginManagerPrivate::loadPlugins spec" << spec << spec->name() << spec->version() << "data" << spec->d << "state" << spec->state() << "loadPlugin Running";
        loadPlugin(spec, PluginSpec::Running);
        if (spec->state() == PluginSpec::Running) {
            delayedInitializeQueue.push(spec);
        } else {
            // Plugin initialization failed, so cleanup after it
            qDebug() << "PluginManagerPrivate::loadPlugins spec" << spec << spec->name() << spec->version() << "data" << spec->d << "state" << spec->state() << "spec->d->kill()";
            spec->d->kill();
        }
    });
    qDebug() << "PluginManagerPrivate::loadPlugins emit q->pluginsChanged()";
    emit q->pluginsChanged();
    Utils::setMimeStartupPhase(MimeStartupPhase::UpAndRunning);

    delayedInitializeTimer = new QTimer;
    delayedInitializeTimer->setInterval(DELAYED_INITIALIZE_INTERVAL);
    delayedInitializeTimer->setSingleShot(true);
    connect(delayedInitializeTimer, &QTimer::timeout,
            this, &PluginManagerPrivate::nextDelayedInitialize);
    delayedInitializeTimer->start();
}

/*!
    \internal
*/
void PluginManagerPrivate::shutdown()
{
    stopAll();
    if (!asynchronousPlugins.isEmpty()) {
        shutdownEventLoop = new QEventLoop;
        shutdownEventLoop->exec();
    }
    deleteAll();
#ifdef WITH_TESTS
    if (PluginManager::isScenarioRunning("TestModelManagerInterface")) {
        qDebug() << "Point 2: Expect the next call to Point 3 triggers a crash";
        QThread::currentThread()->sleep(5);
    }
#endif
    if (!allObjects.isEmpty()) {
        qDebug() << "There are" << allObjects.size() << "objects left in the plugin manager pool.";
        // Intentionally split debug info here, since in case the list contains
        // already deleted object we get at least the info about the number of objects;
        qDebug() << "The following objects left in the plugin manager pool:" << allObjects;
    }
}

/*!
    \internal
*/
void PluginManagerPrivate::asyncShutdownFinished()
{
    auto *plugin = qobject_cast<IPlugin *>(sender());
    Q_ASSERT(plugin);
    asynchronousPlugins.remove(plugin->pluginSpec());
    if (asynchronousPlugins.isEmpty())
        shutdownEventLoop->exit();
}

/*!
    \internal
*/
const QVector<PluginSpec *> PluginManagerPrivate::loadQueue()
{
    QVector<PluginSpec *> queue;
    for (PluginSpec *spec : qAsConst(pluginSpecs)) {
        QVector<PluginSpec *> circularityCheckQueue;
        loadQueue(spec, queue, circularityCheckQueue);
    }
    return queue;
}

/*!
    \internal
*/
bool PluginManagerPrivate::loadQueue(PluginSpec *spec,
                                     QVector<PluginSpec *> &queue,
                                     QVector<PluginSpec *> &circularityCheckQueue)
{
    if (queue.contains(spec))
        return true;
    // check for circular dependencies
    if (circularityCheckQueue.contains(spec)) {
        spec->d->hasError = true;
        spec->d->errorString = PluginManager::tr("Circular dependency detected:");
        spec->d->errorString += QLatin1Char('\n');
        int index = circularityCheckQueue.indexOf(spec);
        for (int i = index; i < circularityCheckQueue.size(); ++i) {
            spec->d->errorString.append(PluginManager::tr("%1 (%2) depends on")
                .arg(circularityCheckQueue.at(i)->name()).arg(circularityCheckQueue.at(i)->version()));
            spec->d->errorString += QLatin1Char('\n');
        }
        spec->d->errorString.append(PluginManager::tr("%1 (%2)").arg(spec->name()).arg(spec->version()));
        return false;
    }
    circularityCheckQueue.append(spec);
    // check if we have the dependencies
    if (spec->state() == PluginSpec::Invalid || spec->state() == PluginSpec::Read) {
        queue.append(spec);
        return false;
    }

    // add dependencies
    const QHash<PluginDependency, PluginSpec *> deps = spec->dependencySpecs();
    for (auto it = deps.cbegin(), end = deps.cend(); it != end; ++it) {
        // Skip test dependencies since they are not real dependencies but just force-loaded
        // plugins when running tests
        if (it.key().type == PluginDependency::Test)
            continue;
        PluginSpec *depSpec = it.value();
        if (!loadQueue(depSpec, queue, circularityCheckQueue)) {
            spec->d->hasError = true;
            spec->d->errorString =
                PluginManager::tr("Cannot load plugin because dependency failed to load: %1 (%2)\nReason: %3")
                    .arg(depSpec->name()).arg(depSpec->version()).arg(depSpec->errorString());
            return false;
        }
    }
    // add self
    queue.append(spec);
    return true;
}

class LockFile
{
public:
    static QString filePath(PluginManagerPrivate *pm)
    {
        return QFileInfo(pm->settings->fileName()).absolutePath() + '/'
               + QCoreApplication::applicationName() + '.'
               + QCryptographicHash::hash(QCoreApplication::applicationDirPath().toUtf8(),
                                          QCryptographicHash::Sha1)
                     .left(8)
                     .toHex()
               + ".lock";
    }

    static Utils::optional<QString> lockedPluginName(PluginManagerPrivate *pm)
    {
        const QString lockFilePath = LockFile::filePath(pm);
        if (QFile::exists(lockFilePath)) {
            QFile f(lockFilePath);
            if (f.open(QIODevice::ReadOnly)) {
                const auto pluginName = QString::fromUtf8(f.readLine()).trimmed();
                f.close();
                return pluginName;
            } else {
                qCDebug(pluginLog) << "Lock file" << lockFilePath << "exists but is not readable";
            }
        }
        return {};
    }

    LockFile(PluginManagerPrivate *pm, PluginSpec *spec)
        : m_filePath(filePath(pm))
    {
        QDir().mkpath(QFileInfo(m_filePath).absolutePath());
        QFile f(m_filePath);
        if (f.open(QIODevice::WriteOnly)) {
            f.write(spec->name().toUtf8());
            f.write("\n");
            f.close();
        } else {
            qCDebug(pluginLog) << "Cannot write lock file" << m_filePath;
        }
    }

    ~LockFile() { QFile::remove(m_filePath); }

private:
    QString m_filePath;
};

void PluginManagerPrivate::checkForProblematicPlugins()
{
    if (!enableCrashCheck)
        return;
    const Utils::optional<QString> pluginName = LockFile::lockedPluginName(this);
    if (pluginName) {
        PluginSpec *spec = pluginByName(*pluginName);
        if (spec && !spec->isRequired()) {
            const QSet<PluginSpec *> dependents = PluginManager::pluginsRequiringPlugin(spec);
            auto dependentsNames = Utils::transform<QStringList>(dependents, &PluginSpec::name);
            std::sort(dependentsNames.begin(), dependentsNames.end());
            const QString dependentsList = dependentsNames.join(", ");
            const QString pluginsMenu = HostOsInfo::isMacHost()
                                            ? tr("%1 > About Plugins")
                                                  .arg(QGuiApplication::applicationDisplayName())
                                            : tr("Help > About Plugins");
            const QString otherPluginsText
                = tr("If you temporarily disable %1, the following plugins that depend on "
                     "it are also disabled: %2.\n\n")
                      .arg(spec->name(), dependentsList);
            const QString detailsText = (dependents.isEmpty() ? QString() : otherPluginsText)
                                        + tr("Disable plugins permanently in %1.").arg(pluginsMenu);
            const QString text = tr("The last time you started %1, it seems to have closed because "
                                    "of a problem with the \"%2\" "
                                    "plugin. Temporarily disable the plugin?")
                                     .arg(QGuiApplication::applicationDisplayName(), spec->name());
            QMessageBox dialog;
            dialog.setIcon(QMessageBox::Question);
            dialog.setText(text);
            dialog.setDetailedText(detailsText);
            QPushButton *disableButton = dialog.addButton(tr("Disable Plugin"),
                                                          QMessageBox::AcceptRole);
            dialog.addButton(tr("Continue"), QMessageBox::RejectRole);
            dialog.exec();
            if (dialog.clickedButton() == disableButton) {
                spec->d->setForceDisabled(true);
                for (PluginSpec *other : dependents)
                    other->d->setForceDisabled(true);
                enableDependenciesIndirectly();
            }
        }
    }
}

void PluginManager::checkForProblematicPlugins()
{
    d->checkForProblematicPlugins();
}

/*!
    \internal
*/
void PluginManagerPrivate::loadPlugin(PluginSpec *spec, PluginSpec::State destState)
{
    if (spec->hasError() || spec->state() != destState-1)
        return;

    // don't load disabled plugins.
    if (!spec->isEffectivelyEnabled() && destState == PluginSpec::Loaded)
        return;

    std::unique_ptr<LockFile> lockFile;
    if (enableCrashCheck && destState < PluginSpec::Stopped)
        lockFile.reset(new LockFile(this, spec));

    switch (destState) {
    case PluginSpec::Running:
        profilingReport(">initializeExtensions", spec);
        spec->d->initializeExtensions();
        profilingReport("<initializeExtensions", spec);
        return;
    case PluginSpec::Deleted:
        profilingReport(">delete", spec);
        spec->d->kill();
        profilingReport("<delete", spec);
        return;
    default:
        break;
    }
    // check if dependencies have loaded without error
    const QHash<PluginDependency, PluginSpec *> deps = spec->dependencySpecs();
    for (auto it = deps.cbegin(), end = deps.cend(); it != end; ++it) {
        if (it.key().type != PluginDependency::Required)
            continue;
        PluginSpec *depSpec = it.value();
        if (depSpec->state() != destState) {
            spec->d->hasError = true;
            spec->d->errorString =
                PluginManager::tr("Cannot load plugin because dependency failed to load: %1(%2)\nReason: %3")
                    .arg(depSpec->name()).arg(depSpec->version()).arg(depSpec->errorString());
            return;
        }
    }
    switch (destState) {
    case PluginSpec::Loaded:
        profilingReport(">loadLibrary", spec);
        spec->d->loadLibrary();
        profilingReport("<loadLibrary", spec);
        break;
    case PluginSpec::Initialized:
        profilingReport(">initializePlugin", spec);
        spec->d->initializePlugin();
        profilingReport("<initializePlugin", spec);
        break;
    case PluginSpec::Stopped:
        profilingReport(">stop", spec);
        if (spec->d->stop() == IPlugin::AsynchronousShutdown) {
            asynchronousPlugins << spec;
            connect(spec->plugin(), &IPlugin::asynchronousShutdownFinished,
                    this, &PluginManagerPrivate::asyncShutdownFinished);
        }
        profilingReport("<stop", spec);
        break;
    default:
        break;
    }
}

/*!
    \internal
*/
void PluginManagerPrivate::setPluginPaths(const QStringList &paths)
{
    qCDebug(pluginLog) << "Plugin search paths:" << paths;
    qCDebug(pluginLog) << "Required IID:" << pluginIID;
    pluginPaths = paths;
    readSettings();
    readPluginPaths();
}

static const QStringList pluginFiles(const QStringList &pluginPaths)
{
    QStringList pluginFiles;
    QStringList searchPaths = pluginPaths;
    while (!searchPaths.isEmpty()) {
        const QDir dir(searchPaths.takeFirst());
        const QFileInfoList files = dir.entryInfoList(QDir::Files | QDir::NoSymLinks);
        const QStringList absoluteFilePaths = Utils::transform(files, &QFileInfo::absoluteFilePath);
        pluginFiles += Utils::filtered(absoluteFilePaths, [](const QString &path) { return QLibrary::isLibrary(path); });
        const QFileInfoList dirs = dir.entryInfoList(QDir::Dirs|QDir::NoDotAndDotDot);
        searchPaths += Utils::transform(dirs, &QFileInfo::absoluteFilePath);
    }
    return pluginFiles;
}

/*!
    \internal
*/
void PluginManagerPrivate::readPluginPaths()
{
    qDeleteAll(pluginSpecs);
    pluginSpecs.clear();
    pluginCategories.clear();

    // default
    pluginCategories.insert(QString(), QVector<PluginSpec *>());

    // from the file system
    for (const QString &pluginFile : pluginFiles(pluginPaths)) {
        PluginSpec *spec = PluginSpec::read(pluginFile);
        if (spec) // Qt Creator plugin
            pluginSpecs.append(spec);
    }
    // static
    for (const QStaticPlugin &plugin : QPluginLoader::staticPlugins()) {
        PluginSpec *spec = PluginSpec::read(plugin);
        if (spec) // Qt Creator plugin
            pluginSpecs.append(spec);
    }

    for (PluginSpec *spec : pluginSpecs) {
        // defaultDisabledPlugins and defaultEnabledPlugins from install settings
        // is used to override the defaults read from the plugin spec
        if (spec->isEnabledByDefault() && defaultDisabledPlugins.contains(spec->name())) {
            spec->d->setEnabledByDefault(false);
            spec->d->setEnabledBySettings(false);
        } else if (!spec->isEnabledByDefault() && defaultEnabledPlugins.contains(spec->name())) {
            spec->d->setEnabledByDefault(true);
            spec->d->setEnabledBySettings(true);
        }
        if (!spec->isEnabledByDefault() && forceEnabledPlugins.contains(spec->name()))
            spec->d->setEnabledBySettings(true);
        if (spec->isEnabledByDefault() && disabledPlugins.contains(spec->name()))
            spec->d->setEnabledBySettings(false);

        pluginCategories[spec->category()].append(spec);
    }
    resolveDependencies();
    enableDependenciesIndirectly();
    // ensure deterministic plugin load order by sorting
    Utils::sort(pluginSpecs, &PluginSpec::name);
    emit q->pluginsChanged();
}

void PluginManagerPrivate::resolveDependencies()
{
    for (PluginSpec *spec : qAsConst(pluginSpecs))
        spec->d->resolveDependencies(pluginSpecs);
}

void PluginManagerPrivate::enableDependenciesIndirectly()
{
    for (PluginSpec *spec : qAsConst(pluginSpecs))
        spec->d->enabledIndirectly = false;
    // cannot use reverse loadQueue here, because test dependencies can introduce circles
    QVector<PluginSpec *> queue = Utils::filtered(pluginSpecs, &PluginSpec::isEffectivelyEnabled);
    while (!queue.isEmpty()) {
        PluginSpec *spec = queue.takeFirst();
        queue += spec->d->enableDependenciesIndirectly(containsTestSpec(spec));
    }
}

// Look in argument descriptions of the specs for the option.
PluginSpec *PluginManagerPrivate::pluginForOption(const QString &option, bool *requiresArgument) const
{
    // Look in the plugins for an option
    *requiresArgument = false;
    for (PluginSpec *spec : qAsConst(pluginSpecs)) {
        PluginArgumentDescription match = Utils::findOrDefault(spec->argumentDescriptions(),
                                                               [option](PluginArgumentDescription pad) {
                                                                   return pad.name == option;
                                                               });
        if (!match.name.isEmpty()) {
            *requiresArgument = !match.parameter.isEmpty();
            return spec;
        }
    }
    return nullptr;
}

PluginSpec *PluginManagerPrivate::pluginByName(const QString &name) const
{
    return Utils::findOrDefault(pluginSpecs, [name](PluginSpec *spec) { return spec->name() == name; });
}

void PluginManagerPrivate::initProfiling()
{
    if (m_profileTimer.isNull()) {
        m_profileTimer.reset(new QElapsedTimer);
        m_profileTimer->start();
        m_profileElapsedMS = 0;
        qDebug("Profiling started");
    } else {
        m_profilingVerbosity++;
    }
}

void PluginManagerPrivate::profilingReport(const char *what, const PluginSpec *spec /* = 0 */)
{
    if (!m_profileTimer.isNull()) {
        const int absoluteElapsedMS = int(m_profileTimer->elapsed());
        const int elapsedMS = absoluteElapsedMS - m_profileElapsedMS;
        m_profileElapsedMS = absoluteElapsedMS;
        if (spec)
            qDebug("%-22s %-22s %8dms (%8dms)", what, qPrintable(spec->name()), absoluteElapsedMS, elapsedMS);
        else
            qDebug("%-45s %8dms (%8dms)", what, absoluteElapsedMS, elapsedMS);
        if (what && *what == '<') {
            QString tc;
            if (spec) {
                m_profileTotal[spec] += elapsedMS;
                tc = spec->name() + '_';
            }
            tc += QString::fromUtf8(QByteArray(what + 1));
            Utils::Benchmarker::report("loadPlugins", tc, elapsedMS);
        }
    }
}

void PluginManagerPrivate::profilingSummary() const
{
    if (!m_profileTimer.isNull()) {
        QMultiMap<int, const PluginSpec *> sorter;
        int total = 0;

        auto totalEnd = m_profileTotal.constEnd();
        for (auto it = m_profileTotal.constBegin(); it != totalEnd; ++it) {
            sorter.insert(it.value(), it.key());
            total += it.value();
        }

        auto sorterEnd = sorter.constEnd();
        for (auto it = sorter.constBegin(); it != sorterEnd; ++it)
            qDebug("%-22s %8dms   ( %5.2f%% )", qPrintable(it.value()->name()),
                it.key(), 100.0 * it.key() / total);
         qDebug("Total: %8dms", total);
         Utils::Benchmarker::report("loadPlugins", "Total", total);
    }
}

static inline QString getPlatformName()
{
    if (HostOsInfo::isMacHost())
        return QLatin1String("OS X");
    else if (HostOsInfo::isAnyUnixHost())
        return QLatin1String(HostOsInfo::isLinuxHost() ? "Linux" : "Unix");
    else if (HostOsInfo::isWindowsHost())
        return QLatin1String("Windows");
    return QLatin1String("Unknown");
}

QString PluginManager::platformName()
{
    static const QString result = getPlatformName() + " (" + QSysInfo::prettyProductName() + ')';
    return result;
}

bool PluginManager::isInitializationDone()
{
    return d->m_isInitializationDone;
}

/*!
    Retrieves one object with \a name from the object pool.
    \sa addObject()
*/

QObject *PluginManager::getObjectByName(const QString &name)
{
    QReadLocker lock(&d->m_lock);
    return Utils::findOrDefault(allObjects(), [&name](const QObject *obj) {
        return obj->objectName() == name;
    });
}

} // ExtensionSystem
