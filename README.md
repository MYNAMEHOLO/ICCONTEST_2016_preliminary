## 這是IC競賽2016年的題目 結果達到A等級
本題描述一個LBP(LOCAL BINARY Patterns)的演算電路，本文章僅供學術分享與心得交流，希望可以幫助到有準備參加比賽練習考古題的同學。

這一次的競賽當中要求**Simulation Timing * Cell Area <= 12,000,000,000為CLASS A**
這次實際應用One hot encoding的方式進行代碼設計，並且在compiler directives使用 
**sysnopsys parallel_case**來進行onehot的優化。

最終結果為
* Simulation Time: 1047858 ns
* Cell Area: 9984 (dcnxt使用compile ultra指令合成)
* 成績結果為 Class A



由於尊重主辦方，所有的設計及製程文件請到`https://www.iccontest2023.com.tw/` 
當中下載，本文僅提供 Source Code 及 Timing/Area log 做為參考
歡迎大家一起交流分享。
