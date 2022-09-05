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

#include "introductionwidget.h"

#include <extensionsystem/iplugin.h>
#include <extensionsystem/pluginmanager.h>

#include <app/app_version.h>

#include <coreplugin/actionmanager/actioncontainer.h>
#include <coreplugin/actionmanager/actionmanager.h>
#include <coreplugin/actionmanager/command.h>
#include <coreplugin/coreconstants.h>
#include <coreplugin/coreicons.h>
#include <coreplugin/icore.h>
#include <coreplugin/imode.h>
#include <coreplugin/iwelcomepage.h>
#include <coreplugin/iwizardfactory.h>
#include <coreplugin/modemanager.h>
#include <coreplugin/welcomepagehelper.h>

#include <utils/algorithm.h>
#include <utils/fileutils.h>
#include <utils/hostosinfo.h>
#include <utils/icon.h>
#include <utils/porting.h>
#include <utils/qtcassert.h>
#include <utils/styledbar.h>
#include <utils/theme/theme.h>
#include <utils/treemodel.h>

#include <QDesktopServices>
#include <QHeaderView>
#include <QLabel>
#include <QMouseEvent>
#include <QPainter>
#include <QScrollArea>
#include <QStackedWidget>
#include <QTimer>
#include <QVBoxLayout>
#include <QDebug>
#include <iostream>

using namespace Core;
using namespace Core::WelcomePageHelpers;
using namespace ExtensionSystem;
using namespace Utils;

namespace Welcome {
namespace Internal {

class TopArea;
class SideArea;
class BottomArea;

const char currentPageSettingsKeyC[] = "Welcome2Tab";
constexpr int buttonSpacing = 16;

static QColor themeColor(Theme::Color role)
{
    return Utils::creatorTheme()->color(role);
}

static void addWeakVerticalSpacerToLayout(QVBoxLayout *layout, int maximumSize)
{
    auto weakSpacer = new QWidget;
    weakSpacer->setMaximumHeight(maximumSize);
    weakSpacer->setMinimumHeight(buttonSpacing);
    weakSpacer->setSizePolicy(QSizePolicy::Ignored, QSizePolicy::Maximum);
    layout->addWidget(weakSpacer);
    layout->setStretchFactor(weakSpacer, 1);
}

class ResizeSignallingWidget : public QWidget
{
    Q_OBJECT

public:
    void resizeEvent(QResizeEvent *event);

signals:
    void resized(const QSize &size, const QSize &oldSize);
};

void ResizeSignallingWidget::resizeEvent(QResizeEvent *event)
{
    emit resized(event->size(), event->oldSize());
}

class WelcomeMode : public IMode
{
    Q_OBJECT

public:
    WelcomeMode();
    ~WelcomeMode();

    void initPlugins();

    bool openDroppedFiles(const QList<QUrl> &urls);

private:
    void addPage(IWelcomePage *page);

    ResizeSignallingWidget *m_modeWidget;
    QStackedWidget *m_pageStack;
    TopArea *m_topArea;
    SideArea *m_sideArea;
    BottomArea *m_bottomArea;
    QList<IWelcomePage *> m_pluginList;
    QList<WelcomePageButton *> m_pageButtons;
    Id m_activePage;
    Id m_defaultPage;
};

class WelcomePlugin final : public ExtensionSystem::IPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QtCreatorPlugin" FILE "Welcome.json")

public:
    ~WelcomePlugin() final { delete m_welcomeMode; }

    bool initialize(const QStringList &arguments, QString *) final
    {
        std::cout << "WelcomePlugin::initialize" << this;
        qDebug() << "WelcomePlugin::initialize" << this;

        m_welcomeMode = new WelcomeMode;

        auto introAction = new QAction(tr("UI Tour"), this);
        connect(introAction, &QAction::triggered, this, []() {
            auto intro = new IntroductionWidget(ICore::mainWindow());
            intro->show();
        });
        Command *cmd = ActionManager::registerAction(introAction, "Welcome.UITour");
        ActionContainer *mhelp = ActionManager::actionContainer(Core::Constants::M_HELP);
        if (QTC_GUARD(mhelp))
            mhelp->addAction(cmd, Core::Constants::G_HELP_HELP);

        if (!arguments.contains("-notour")) {
            connect(ICore::instance(), &ICore::coreOpened, this, []() {
                IntroductionWidget::askUserAboutIntroduction(ICore::mainWindow(),
                                                             ICore::settings());
            }, Qt::QueuedConnection);
        }

        return true;
    }

    void extensionsInitialized() final
    {
        std::cout << "WelcomePlugin::extensionsInitialized" << this;
        qDebug() << "WelcomePlugin::extensionsInitialized" << this;

        m_welcomeMode->initPlugins();
        ModeManager::activateMode(m_welcomeMode->id());
    }

    WelcomeMode *m_welcomeMode = nullptr;
};

class TopArea : public QWidget
{
    Q_OBJECT

public:
    TopArea(QWidget *parent = nullptr)
        : QWidget(parent)
    {
        setAutoFillBackground(true);
        setMinimumHeight(11); // For compact state
        setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Minimum);
        setPalette(themeColor(Theme::Welcome_BackgroundPrimaryColor));

        m_title = new QWidget;

        auto hbox = new QHBoxLayout(m_title);
        hbox->setSpacing(0);
        hbox->setContentsMargins(HSpacing - 5, 2, 0, 2);

        {
            auto ideIconLabel = new QLabel;
            const QPixmap logo = Core::Icons::QTCREATORLOGO_BIG.pixmap();
            ideIconLabel->setPixmap(logo.scaled(logo.size() * 0.6, Qt::IgnoreAspectRatio,
                                                Qt::SmoothTransformation));
            hbox->addWidget(ideIconLabel, 0);

            hbox->addSpacing(16);

            QFont welcomeFont = brandFont();
            welcomeFont.setPixelSize(30);
            welcomeFont.setWeight(QFont::Light);
            welcomeFont.setWordSpacing(2);

            auto welcomeLabel = new QLabel("Welcome to");
            welcomeLabel->setFont(welcomeFont);
            hbox->addWidget(welcomeLabel, 0);

            hbox->addSpacing(8);

            auto ideNameLabel = new QLabel(Core::Constants::IDE_DISPLAY_NAME);
            ideNameLabel->setFont(welcomeFont);
            ideNameLabel->setAlignment(Qt::AlignLeft | Qt::AlignVCenter);
            QPalette pal = palette();
            pal.setColor(QPalette::WindowText, themeColor(Theme::Welcome_AccentColor));
            ideNameLabel->setPalette(pal);
            hbox->addWidget(ideNameLabel, 1);
        }

        auto mainLayout = new QHBoxLayout(this);
        mainLayout->setContentsMargins(0, 0, 0, 0);
        mainLayout->addWidget(m_title);
    }

    void setCompact(bool compact)
    {
        m_title->setVisible(!compact);
    }

private:
    QWidget *m_title;
};

class SideArea : public QScrollArea
{
    Q_OBJECT

public:
    SideArea(QWidget *parent = nullptr)
        : QScrollArea(parent)
    {
        setWidgetResizable(true);
        setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
        setFrameShape(QFrame::NoFrame);
        setSizePolicy(QSizePolicy::Maximum, QSizePolicy::Ignored);

        auto mainWidget = new QWidget(this);
        mainWidget->setAutoFillBackground(true);
        mainWidget->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Minimum);
        mainWidget->setPalette(themeColor(Theme::Welcome_BackgroundPrimaryColor));

        auto vbox = new QVBoxLayout(mainWidget);
        vbox->setSpacing(0);
        vbox->setContentsMargins(HSpacing, 0, HSpacing, 0);

        {
            auto projectVBox = new QVBoxLayout;
            projectVBox->setSpacing(buttonSpacing);
            auto newButton = new WelcomePageButton(mainWidget);
            newButton->setText(tr("Create Project..."));
            newButton->setWithAccentColor(true);
            newButton->setOnClicked([] {
                QAction *openAction = ActionManager::command(Core::Constants::NEW)->action();
                openAction->trigger();
            });

            auto openButton = new WelcomePageButton(mainWidget);
            openButton->setText(tr("Open Project..."));
            openButton->setWithAccentColor(true);
            openButton->setOnClicked([] {
                QAction *openAction = ActionManager::command(Core::Constants::OPEN)->action();
                openAction->trigger();
            });

            projectVBox->addWidget(newButton);
            projectVBox->addWidget(openButton);
            vbox->addItem(projectVBox);
        }

        addWeakVerticalSpacerToLayout(vbox, 34);

        {
            auto newVBox = new QVBoxLayout;
            newVBox->setSpacing(buttonSpacing / 3);
            vbox->addItem(newVBox);

            auto newLabel = new QLabel(tr("New to Qt?"), mainWidget);
            newLabel->setFont(brandFont());
            newLabel->setAlignment(Qt::AlignHCenter);
            newVBox->addWidget(newLabel);

            auto getStartedButton = new WelcomePageButton(mainWidget);
            getStartedButton->setText(tr("Get Started"));
            getStartedButton->setOnClicked([] {
                QDesktopServices::openUrl(
                    QString("qthelp://org.qt-project.qtcreator/doc/creator-getting-started.html"));
            });
            newVBox->addWidget(getStartedButton);
        }

        addWeakVerticalSpacerToLayout(vbox, 56);

        {
            auto l = m_pluginButtons = new QVBoxLayout;
            l->setSpacing(buttonSpacing);
            vbox->addItem(l);
        }

        vbox->addStretch(1);

        setWidget(mainWidget);
    }

    QVBoxLayout *m_pluginButtons = nullptr;
};

class BottomArea : public QWidget
{
    Q_OBJECT

public:
    BottomArea(QWidget *parent = nullptr)
        : QWidget(parent)
    {
        setAutoFillBackground(true);
        setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Minimum);
        setPalette(themeColor(Theme::Welcome_BackgroundPrimaryColor));

        auto hbox = new QHBoxLayout(this);
        hbox->setSpacing(0);
        hbox->setContentsMargins(0, 2 * ItemGap, HSpacing, 2 * ItemGap);

        const QList<QPair<QString, QString> > links {
            { tr("Get Qt"), "https://www.qt.io/download" },
            { tr("Qt Account"), "https://account.qt.io" },
            { tr("Online Community"), "https://forum.qt.io" },
            { tr("Blogs"), "https://planet.qt.io" },
            { tr("User Guide"), "qthelp://org.qt-project.qtcreator/doc/index.html" },
        };
        for (const QPair<QString, QString> &link : links) {
            auto button = new WelcomePageButton(this);
            button->setSize(WelcomePageButton::SizeSmall);
            button->setText(link.first);
            button->setOnClicked([link]{ QDesktopServices::openUrl(link.second); });
            button->setWithAccentColor(true);
            button->setMaximumWidth(220);
            button->setToolTip(link.second);
            if (hbox->count() > 0)
                hbox->addStretch(1);
            hbox->addWidget(button, 20);
        }
    }
};

WelcomeMode::WelcomeMode()
{
    std::cout << "WelcomeMode::WelcomeMode" << this;
    qDebug() << "WelcomeMode::WelcomeMode" << this;

    setDisplayName(tr("Welcome"));

    const Icon CLASSIC(":/welcome/images/mode_welcome.png");
    const Icon FLAT({{":/welcome/images/mode_welcome_mask.png",
                      Theme::IconsBaseColor}});
    const Icon FLAT_ACTIVE({{":/welcome/images/mode_welcome_mask.png",
                             Theme::IconsModeWelcomeActiveColor}});
    setIcon(Icon::modeIcon(CLASSIC, FLAT, FLAT_ACTIVE));

    setPriority(Constants::P_MODE_WELCOME);
    setId(Constants::MODE_WELCOME);
    setContextHelp("Qt Creator Manual");
    setContext(Context(Constants::C_WELCOME_MODE));

    QPalette palette = creatorTheme()->palette();
    palette.setColor(QPalette::Window, themeColor(Theme::Welcome_BackgroundPrimaryColor));

    m_modeWidget = new ResizeSignallingWidget;
    m_modeWidget->setPalette(palette);
    connect(m_modeWidget, &ResizeSignallingWidget::resized,
            [this](const QSize &size, const QSize &) {
        const bool hideSideArea = size.width() <= 750;
        const bool hideBottomArea = size.width() <= 850;
        const bool compactVertically = size.height() <= 530;
        QTimer::singleShot(0, [this, hideSideArea, hideBottomArea, compactVertically]() {
            m_sideArea->setVisible(!hideSideArea);
            m_bottomArea->setVisible(!(hideBottomArea || compactVertically));
            m_topArea->setCompact(compactVertically);
        });
    });

    m_sideArea = new SideArea(m_modeWidget);

    m_pageStack = new QStackedWidget(m_modeWidget);
    palette.setColor(QPalette::Window, themeColor(Theme::Welcome_BackgroundSecondaryColor));
    m_pageStack->setPalette(palette);
    m_pageStack->setObjectName("WelcomeScreenStackedWidget");
    m_pageStack->setAutoFillBackground(true);

    m_topArea = new TopArea;
    m_bottomArea = new BottomArea;

    auto layout = new QGridLayout(m_modeWidget);
    layout->addWidget(new StyledBar(m_modeWidget), 0, 0, 1, 2);
    layout->addWidget(m_topArea, 1, 0, 1, 2);
    layout->addWidget(m_sideArea, 2, 0, 2, 1);
    layout->addWidget(m_pageStack, 2, 1, 1, 1);
    layout->setColumnStretch(1, 10);
    layout->addWidget(m_bottomArea, 3, 1, 1, 1);
    layout->setContentsMargins(0, 0, 0, 0);
    layout->setSpacing(0);

    setWidget(m_modeWidget);
}

WelcomeMode::~WelcomeMode()
{
    QtcSettings *settings = ICore::settings();
    settings->setValueWithDefault(currentPageSettingsKeyC,
                                  m_activePage.toSetting(),
                                  m_defaultPage.toSetting());
    delete m_modeWidget;
}

void WelcomeMode::initPlugins()
{
    std::cout << "WelcomeMode::initPlugins" << this;
    qDebug() << "WelcomeMode::initPlugins" << this;

    QSettings *settings = ICore::settings();
    m_activePage = Id::fromSetting(settings->value(currentPageSettingsKeyC));

    for (IWelcomePage *page : IWelcomePage::allWelcomePages())
        addPage(page);

    if (!m_pageButtons.isEmpty()) {
        const int welcomeIndex = Utils::indexOf(m_pluginList,
                                                Utils::equal(&IWelcomePage::id,
                                                             Utils::Id("Examples")));
        const int defaultIndex = welcomeIndex >= 0 ? welcomeIndex : 0;
        m_defaultPage = m_pluginList.at(defaultIndex)->id();
        if (!m_activePage.isValid())
            m_pageButtons.at(defaultIndex)->click();
    }
}

bool WelcomeMode::openDroppedFiles(const QList<QUrl> &urls)
{
    const QList<QUrl> localUrls = Utils::filtered(urls, &QUrl::isLocalFile);
    if (!localUrls.isEmpty()) {
        QTimer::singleShot(0, [localUrls]() {
            ICore::openFiles(Utils::transform(localUrls, &FilePath::fromUrl), ICore::SwitchMode);
        });
        return true;
    }
    return false;
}

void WelcomeMode::addPage(IWelcomePage *page)
{
    int idx;
    int pagePriority = page->priority();
    for (idx = 0; idx != m_pluginList.size(); ++idx) {
        if (m_pluginList.at(idx)->priority() >= pagePriority)
            break;
    }
    auto pageButton = new WelcomePageButton(m_sideArea->widget());
    auto pageId = page->id();
    pageButton->setText(page->title());
    pageButton->setActiveChecker([this, pageId] { return m_activePage == pageId; });

    m_pluginList.insert(idx, page);
    m_pageButtons.insert(idx, pageButton);

    m_sideArea->m_pluginButtons->insertWidget(idx, pageButton);

    QWidget *stackPage = page->createWidget();
    stackPage->setAutoFillBackground(true);
    m_pageStack->insertWidget(idx, stackPage);

    connect(page, &QObject::destroyed, this, [this, page, stackPage, pageButton] {
        m_pluginList.removeOne(page);
        m_pageButtons.removeOne(pageButton);
        delete pageButton;
        delete stackPage;
    });

    auto onClicked = [this, pageId, stackPage] {
        m_activePage = pageId;
        m_pageStack->setCurrentWidget(stackPage);
        for (WelcomePageButton *pageButton : qAsConst(m_pageButtons))
            pageButton->recheckActive();
    };

    pageButton->setOnClicked(onClicked);
    if (pageId == m_activePage)
        onClicked();
}

} // namespace Internal
} // namespace Welcome

#include "welcomeplugin.moc"
