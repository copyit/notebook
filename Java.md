

## Java的神奇(keng)

记录一下Java与C的不同点，感受Thinking in Java

### 变量名称

$就是个普通字符，可以int $a; //php表示mdzz

### main函数

必须是public static void main(String[] args)

如果没有static，编译能通过但没有执行结果？// 待考证，eclipse拒绝运行

### if

if中的东西必须是boolean类型的值，不能把int放入if中

if ( a = true )的坑还是存在的，允许赋值作为if条件

### %取余的结果

要考虑到负数的结果啊~（和C一致）

### 数组声明引用、初始化之后才能用

不允许int a[5]; 只能int[] a = new int [5];

如果要初始化 int[] b = new int[]{1,2}; 可以简化为 int c[] = {1,2};

但不能出现d={1,2}; 不允许大括号这玩意用来赋值，只准用于初始化

### switch

boolean是不行的；String是可以的！

case是不能重复的（和C一致）

### ==

一定是比较地址，如果"haha"在代码中出现两次，他们的地址是一样的

### 类型自动提升

int long float double

最高出现哪个全部提升为哪个，都没有就全部提升为int

所以要这么写才能把byte*2：byte b = (byte)(a*2);

### 内部类

加上static后：可以不用实例化外部类就创建对象，不能访问外部类非静态的数据

不加static：需要先实例化外部类new OuterClass().new InnerClass()

### 数组的new不创建对象

对象数组的new是不会创建对象的

例如 `A[] a=new A[5];` 并不会创建5个A类型的对象，只是5个空引用

## 异常处理中的资源释放问题

From: http://stackoverflow.com/questions/8080649/do-i-have-to-close-fileoutputstream-which-is-wrapped-by-printstream

在Java7中引入了ARM(自动资源管理)，并不需要手动释放资源

以下这种把变量声明放到try后的括号里面，不对资源手动释放的写法是可以的，没有任何错误

```
public static void main(String args[]) throws IOException { 
    try (PrintStream ps = new PrintStream(new FileOutputStream("myfile.txt"))) {
        ps.println("This data is written to a file:");
        System.out.println("Write successfully");
    } catch (IOException e) {
        System.err.println("Error in writing to file");
        throw e;
    }
}
```

普通的try-catch是不够的，需要在finally中释放资源：

```
public static void main(String args[]) throws IOException { 
    PrintStream ps = null;

    try {
        ps = new PrintStream(new FileOutputStream("myfile.txt"));
        ps.println("This data is written to a file:");
        System.out.println("Write successfully");
    } catch (IOException e) {
        System.err.println("Error in writing to file");
        throw e;
    } finally {
        if (ps != null) ps.close();
    }
}
```

----

## JVM启动时的内存参数

From: http://blog.chinaunix.net/uid-26863299-id-3559878.html

常见参数种类：配置堆区的（-Xms 、-Xmx、-XX:newSize、-XX:MaxnewSize、-Xmn）、配置非堆区（-XX:PermSize、-XX:MaxPermSize）。

堆区的：

1、-Xms ：表示java虚拟机堆区内存初始内存分配的大小

2、-Xmx： 表示java虚拟机堆区内存可被分配的最大上限，通常会将 -Xms 与 -Xmx两个参数的配置相同的值，其目的是为了能够在java垃圾回收机制清理完堆区后不需要重新分隔计算堆区的大小而浪费资源。

3、-XX:newSize：表示新生代初始内存的大小，应该小于 -Xms的值；

4、-XX:MaxnewSize：表示新生代可被分配的内存的最大上限；当然这个值应该小于 -Xmx的值；

5、-Xmn：对 -XX:newSize、-XX:MaxnewSize两个参数的同时配置

非堆区的：

1、-XX:PermSize：表示非堆区初始内存分配大小，名字来源于permanent size

2、-XX:MaxPermSize：表示对非堆区分配的内存的最大上限。

最大堆内存与最大非堆内存的和不能够超出操作系统的可用内存。
