# Predicting Name Popularity

When picking a name for their child, a lot of parents try to choose something more or less unique, but they end up picking the same option. Making a forecast of name popularity is not a trivial task. A casual glance at the distribution of a particular name over time (using data from Social Security Card Applications) shows that jumps in popularity are often quite unexpected. Sometimes these jumps can be explained by some external factors, like celebrity names. For example, there was a spike in popularity of Jacqueline when Jacqueline Kennedy was the First Lady.

![Graph 1: Jacqueline](https://raw.githubusercontent.com/evpu/Predicting-Name-Popularity/master/Jacqueline.png)

But take the name Emily, right now it is ranked #7 among the most popular names for girls in the USA. Yet, in 1970 it was not in such a high demand. Using all available data before 1970 to make a simple prediction (assuming an autoregressive process, 10 lags because naming might be affected by the names of other kids (born within the last 10 years) that parents see around, and 500 simulation replications to obtain confidence intervals), the forecast falls short of predicting the actual spike in popularity that occurred after 1970. The model works more or less well for Daniel, but for Emily a more sophisticated approach is needed.

![Graph 2: Daniel & Emily](https://raw.githubusercontent.com/evpu/Predicting-Name-Popularity/master/Daniel_Emily.png)
