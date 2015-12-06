Модулі
======

Модулі - це самодостатні програмні блоки, що складаються з [моделей](structure-models.md), [представлень](structure-views.md),
[контролерів](structure-controllers.md) та інших допоміжних компонентів. Кінцеві користувачі можуть мати доступ до контролерів
модуля, якщо він встановленний у [додатку](structure-applications.md). З цієї причини, модулі
часто розглядаються як міні-додатки. Модулі відрізняються від [додатків](structure-applications.md) тим,
що модулі не можуть бути використані самостійно, а повинні бути всередині додатків.


## Створення модулів <span id="creating-modules"></span>

Модуль розміщується в директорії, яка називається [[yii\base\Module::basePath|базовим шляхом]] модуля.
Всередині директорії є під-директорії, такі як `controllers`, `models`, `views`, які містять контролери,
моделі, представлення та інший код, так само як в додатку. Наступний приклад показує вміст всередині модуля:

```
forum/
    Module.php                   файл класу модуля
    controllers/                 містить файли класів контролерів
        DefaultController.php    файл класу типового контролеру
    models/                      містить файли класів моделей
    views/                       містить файли представлень контролерів та макетів
        layouts/                 містить файли макетів
        default/                 містить файли представлень типового контролера DefaultController
            index.php            файл основного представлення
```


### Класи модуля <span id="module-classes"></span>

Кожний модуль повинен мати унікальний клас модуля, який успадковується від [[yii\base\Module]]. Клас повинен бути розміщенний
безпосередньо в директорії [[yii\base\Module::basePath|базового шляху]] модуля та підтримувати [автозавантаження](concept-autoloading.md).
Під час доступу до модуля буде створено єдиний екземпляр відповідного класу модуля.
Подібно до [екземплярів додатку](structure-applications.md), екземпляри модулів використовуються для поширення доступу до даних та компонентів
у коді всередині модулів.

Далі наведено приклад того, як може виглядати клас модуля:

```php
namespace app\modules\forum;

class Module extends \yii\base\Module
{
    public function init()
    {
        parent::init();

        $this->params['foo'] = 'bar';
        // ...  додатковий код ініціалізації ...
    }
}
```

Якщо метод `init()` містить багато коду ініціалізації властивостей модуля, ви можете зберегти його у вигляді
[конфігурації](concept-configurations.md) та завантажити його за допомогою наступного коду в `init()`:

```php
public function init()
{
    parent::init();
    // ініціалізація модуля за допомогою конфігурації завантаженної з файлу config.php
    \Yii::configure($this, require(__DIR__ . '/config.php'));
}
```

, де файл конфігурації `config.php` може містити наступний вміст, подібно до того як у
[конфігурації додатку](structure-applications.md#application-configurations).

```php
<?php
return [
    'components' => [
        // список конфігурацій компонентів
    ],
    'params' => [
        // список параметрів
    ],
];
```


### Контролери у модулях <span id="controllers-in-modules"></span>

При створенні контролерів у модулі, класи контролерів за домовленістю розміщуються в під-просторі імен `controllers`
простору імен класу модуля. Це також означає, що файли класів контролерів повинні бути
розміщені в директорії `controllers` всередині [[yii\base\Module::basePath|базового шляху]] модуля.
Наприклад, для створення контролера `post` в модулі `forum` показаного у попередньому підрозділі, необхідно
оголосити клас контролера подібно до наведеного:

```php
namespace app\modules\forum\controllers;

use yii\web\Controller;

class PostController extends Controller
{
    // ...
}
```

Можна налаштувати простір імен класів контролерів сконфігурувавши властивість [[yii\base\Module::controllerNamespace]].
У випадку, коли деякі контролери є за межами цього простору імен, можна зробити їх доступними
сконфігурувавши властивість [[yii\base\Module::controllerMap]], подібно до того, [як це робиться у додатку](structure-applications.md#controller-map).


### Представлення у модулях <span id="views-in-modules"></span>

Представлення у модулі повинні бути розміщені в директорії `views` всередині [[yii\base\Module::basePath|базового шляху]] модуля.
Представлення, що формуються контролером модуля, повинні бути розміщені в директорії `views/ControllerID`,
де `ControllerID` відповідає [ідентифікатору контролера](structure-controllers.md#routes). Наприклад, якщо
класом контролера є `PostController`, директорія має бути `views/post` всередині
[[yii\base\Module::basePath|базового шляху]] модуля.

У модулі можна визначити [макет](structure-views.md#layouts), який застосовуватиметься до представлень, що формуються контролерами
модуля. За замовчуванням макет повинен бути розміщенний у директорії `views/layouts`, також необхідно сконфігурувати
властивість [[yii\base\Module::layout]], встановивши імʼя макету. Якщо властивість `layout` не встановлена,
буде використаний макет, налаштованний для додатку.


## Використання модулів <span id="using-modules"></span>

Для використання модуля у додатку просто сконфігуруйте додаток, додавши модуль до переліку у
властивості додатку [[yii\base\Application::modules|modules]]. Наступний код в
[конфігурації додатку](structure-applications.md#application-configurations) використовує модуль `forum`:

```php
[
    'modules' => [
        'forum' => [
            'class' => 'app\modules\forum\Module',
            // ... інші налаштування модуля ...
        ],
    ],
]
```

Властивість [[yii\base\Application::modules|modules]] приймає масив конфігурацій модулів. Кожний ключ масиву
предстваляє *ідентифікатор модуля*, який є унікальним та ідентифікує модуль серед усіх модулів додатку, а відповідним
значенням масиву є [конфігурація](concept-configurations.md) для створення модуля.


### Маршрути <span id="routes"></span>

Подібно до організації доступу до контролерів у додатку, [маршрути](structure-controllers.md#routes) використовуються для адресації
контролерів у модулі. Маршрут для контролера, який належить модулю, повинен починатись з ідентифікатора модуля, далі йдуть
[ідентифікатор контролера](structure-controllers.md#controller-ids) та [ідентифікатор дії](structure-controllers.md#action-ids).
Наприклад, якщо додаток використовує модуль з імʼям `forum`, тоді маршрут
`forum/post/index` буде предствляти дію `index` контролера `post` у модулі. Якщо маршрут
містить лише ідентифікатор модуля, то властивість [[yii\base\Module::defaultRoute]], яка за замовчуванням має значення `default`,
визначатиме які контролер/дію необхідно буде використати. Це означає, що маршрут `forum` предствалятиме контролер `default`
у модулі `forum`.


### Отримання доступу до модулів <span id="accessing-modules"></span>

Всередині модуля часто необхідно отримати екземпляр [класу модуля](#module-classes), щоб мати
доступ до ідентифікатору модуля, параметрів модуля, компонентів модуля і т. д. Це можна зробити, використовуючи наступну концтрукцію:

```php
$module = MyModuleClass::getInstance();
```

де `MyModuleClass` означає імʼя класу модуля, у якому ви зацікавленні. Метод `getInstance()`
поверне екземпляр щойно запитуваного класу модуля. Якщо модуль не було завантажено, метод
поверне null. 

refers to the name of the module class that you are interested in. The `getInstance()` method
will return the currently requested instance of the module class. If the module is not requested, the method will
return null. Note that you do not want to manually create a new instance of the module class because it will be
different from the one created by Yii in response to a request.

> Info: When developing a module, you should not assume the module will use a fixed ID. This is because a module
  can be associated with an arbitrary ID when used in an application or within another module. In order to get
  the module ID, you should use the above approach to get the module instance first, and then get the ID via
  `$module->id`.

You may also access the instance of a module using the following approaches:

```php
// get the child module whose ID is "forum"
$module = \Yii::$app->getModule('forum');

// get the module to which the currently requested controller belongs
$module = \Yii::$app->controller->module;
```

The first approach is only useful when you know the module ID, while the second approach is best used when you
know about the controllers being requested.

Once you have the module instance, you can access parameters and components registered with the module. For example,

```php
$maxPostCount = $module->params['maxPostCount'];
```


### Bootstrapping Modules <span id="bootstrapping-modules"></span>

Some modules may need to be run for every request. The [[yii\debug\Module|debug]] module is such an example.
To do so, list the IDs of such modules in the [[yii\base\Application::bootstrap|bootstrap]] property of the application.

For example, the following application configuration makes sure the `debug` module is always loaded:

```php
[
    'bootstrap' => [
        'debug',
    ],

    'modules' => [
        'debug' => 'yii\debug\Module',
    ],
]
```


## Nested Modules <span id="nested-modules"></span>

Modules can be nested in unlimited levels. That is, a module can contain another module which can contain yet
another module. We call the former *parent module* while the latter *child module*. Child modules must be declared
in the [[yii\base\Module::modules|modules]] property of their parent modules. For example,

```php
namespace app\modules\forum;

class Module extends \yii\base\Module
{
    public function init()
    {
        parent::init();

        $this->modules = [
            'admin' => [
                // you should consider using a shorter namespace here!
                'class' => 'app\modules\forum\modules\admin\Module',
            ],
        ];
    }
}
```

For a controller within a nested module, its route should include the IDs of all its ancestor modules.
For example, the route `forum/admin/dashboard/index` represents the `index` action of the `dashboard` controller
in the `admin` module which is a child module of the `forum` module.

> Info: The [[yii\base\Module::getModule()|getModule()]] method only returns the child module directly belonging
to its parent. The [[yii\base\Application::loadedModules]] property keeps a list of loaded modules, including both
direct children and nested ones, indexed by their class names.


## Best Practices <span id="best-practices"></span>

Modules are best used in large applications whose features can be divided into several groups, each consisting of
a set of closely related features. Each such feature group can be developed as a module which is developed and
maintained by a specific developer or team.

Modules are also a good way of reusing code at the feature group level. Some commonly used features, such as
user management, comment management, can all be developed in terms of modules so that they can be reused easily
in future projects.
