### PMFMDB V1.0
This is a sqlite tools to show database data and run sql, such as sqliteManager tools.
This used FMDB. If you have FMDB in you project, you should not include it when you install.You just input PMFMDB.

### PMFMDB Main Funcation
- You can seach all the table in you database;
- You can execute SQL;
- You can preview the result than you search;
- You can review the history you search;
- You can copy the SQL to run;
- You can select a common SQL to run;
- You can delete all tables

###Installation
- In the directory ./lib.  Drag PMFMDB and FMDB to you project, If you have installed FMDB, you should not drag FMDB to your project.
- Import "PMMainViewController.h" in you view controller when you use.
- You must make the database path is same to your project, and then assign to PMMainViewController

###Usage
There is one main class in PMFMDB:
* `PMMainViewController`- The main view controller that you will present.<br>
</br>

```objective-c
PMMainViewController *mainViewController = [[PMMainViewController alloc] init];
mainViewController.dataPath = [self messageDBPath];
UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainViewController];
[self presentViewController:nav animated:YES completion:nil];
```

###All tables
* Enter to `PMFMDB` page, the main view controller.
* Click `All tables` you will enter to `PMTables` page. You can see all the tables that in you database and the SQL that create table.
* Click cell you will enter to `PMDetail`. You can search data in your table.
* Click top right corner search button, search all the data in your table.
* You can search data with condition what you what.

###Run SQL - Run sql in you data base.
* Add SQL to the file PMExecuteSql.plist which save the SQL you want to execute;
* Enter to `PMFMDB` page, the main view controller;
* Click `Execute SQL` you will enter to `PMSQL` page;
* Click the button `Local SQL`, Select the SQL that you add;
* Click button `Run SQL`

###Show search history
* Enter to `PMFMDB` page, the main view controller;
* Click `The records that you searched` you will enter to `PMCSV` page;
* Click item to preview the results
* Click top right corner trash, you will delete all the records. You should clean up all the records when you publish you APP

###The page

<pre>![](https://github.com/wsyxyxs/PMFMDB-iOS/raw/master/PMFMDB/PMFMDB/pmfmdb.png)</pre>

###Support
If you have any questions, you can send email(`wsyxyxs@126.com`) to me.

###License
PMFMDB is provided under the MIT license. See LICENSE file for details.

###中文
PMFMDB一个基于FMDB分装的一个数据库工具，如果你想实时的查询数据库中的数据，而不想太麻烦，那么你可以试着使用这个工具。PMFMDB基本包含了数据库操作的大部分功能。尤其是当你的数据库经过了加密，使用数据库工具不能查看数据的时候，PMFMDB是一个不错的选择。

###主要功能
- 查询所有的数据库表;
- 执行 SQL 语句;
- 预览查询结果;
- 查看查询记录;
- 复制项目中的SQL语句，执行;
- 选择常用的SQL语句执行;

###安装
- 在.lib目录下，把FMDB和PMFMDB拽入你的项目中，当然如果你的项目中已经包含了FMDB，那么只需要拽人PMFMDB即可.
- 当你使用的时候，导入 "PMMainViewController.h"到项目中的当前文件下.
- 你必须保证数据库的路径和赋值给PMMainViewController的路径是同一个.

###使用
在PMFMDB主要有一个类:
* `PMMainViewController`- 你将要展示的主要的视图控制器. <br>
</br>

```objective-c
PMMainViewController *mainViewController = [[PMMainViewController alloc] init];
mainViewController.dataPath = [self messageDBPath];
UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainViewController];
[self presentViewController:nav animated:YES completion:nil];
// 你可以自己定义一个按钮，点击按钮的时候执行这端代码
```

###获取所有的表
* 进入 `PMFMDB` 页面, 也就是主要的视图控制器.
* 点击 `All tables` 将进入 `PMTables` 页面. 在这个页面中你可以看到所有的表和创建表时使用的SQL语句.
* 点击cell，你将进入 `PMDetail`. 点击导航右上角的按钮，查询所有的数据，或者根据条件查询部分数据.

#执行 SQL - 执行SQL语句.
* 把你想要执行的SQL语句，放入 `PMExecuteSql.plist` 文件中，这个文件目的是让你能够方便的把写好的SQL语句执行，或者自己输入SQL语句，或者选择一个SQL语句模板，当然你可以添加自己常用的SQL语句作为模板，只需把SQL语句放入到文件`PMCommonSql.plist`中;
* 进入 `PMFMDB` 页面, 也就是主要的视图控制器.
* 点击 `Execute SQL` 将进入 `PMSQL` 页;
* 点击按钮 `Local SQL`, 选择你添加的SQL语句;
* 点击 `Run SQL`，将执行SQL语句，如果SQL语句错误，将会提示错误

#显示查询历史记录－历史记录保存了你所有的查询记录，上线的时候一定要记得清除这里的缓存记录
* 进入 `PMFMDB` 页面, 也就是主要的视图控制器.
* 点击 `The records that you searched` 进入 `PMCSV` 页面;
* 点击每一项可以预览查询结果
* 点击导航右上角的按钮即可清除所有的查询记录.

#截图

<pre>![](https://github.com/wsyxyxs/PMFMDB-iOS/raw/master/PMFMDB/PMFMDB/pmfmdb.png)</pre>

#支持
如果你有任何问题可以发邮件给我(`wsyxyxs@126.com`).
