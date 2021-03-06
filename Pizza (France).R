#----------------------------------------------------------------------------------------------------------------
# Packages utilis�s
#----------------------------------------------------------------------------------------------------------------
library(caschrono)
library(forecast)


#----------------------------------------------------------------------------------------------------------------
# S�rie temporelle 'Pizza'
#----------------------------------------------------------------------------------------------------------------
data = read.csv("Pizza (France).csv", skip=1, col.names=c("Mois","France"), row.names=1)     # Chargement
Pizza = ts(data[1:(nrow(data)-12),], start=c(2004, 1), frequency=12)                         # S�rie sans 2019
Pizza2019 = ts(data[(nrow(data)-11):nrow(data),], start=c(2019, 1), frequency=12)            # Donn�es de 2019


#----------------------------------------------------------------------------------------------------------------
# Statistique d�scriptive
#----------------------------------------------------------------------------------------------------------------
# Chronogramme
#-------------
MatX = matrix(data=Pizza, nrow=12)     # La s�rie en forme de matrix
Min = apply(MatX, 2, min)              # D�terminer les minimums par ann�e
Max = apply(MatX, 2, max)              # D�terminer les maximums par ann�e
YearMin = c(2005:2019)                 # Les ann�es minimum
YearMax = c(2004:2018)                 # Les ann�es maximum

plot(Pizza, lwd=2, main="Int�r�t pour le mot 'Pizza' en France", xlab="Temps", ylab="Int�r�t")     # Plot de la s�rie
points(YearMin, Min, col="blue", type = "l")                                                       # Courbe minimum
points(YearMax, Max, col="red", type = "l")                                                        # Courbe maximum


# Month-plot
#-----------
monthplot(Pizza, main="Monthplot de 'Pizza'", ylab="Pizza")     # Month-plot de la s�rie


# Lag-plot
#---------
lag.plot(Pizza, lags=12, main="Lag-plot de 'Pizza'")     # Lag-plot de la s�rie


# D�composition : mod�le additive
#--------------------------------
PizzaAdd = decompose(Pizza, type="additive")     # D�composition en mod�le additif
plot(PizzaAdd)                                   # Plot de la d�composition

plot(Pizza, lwd=2, col="darkgrey",                                              # Plot de la s�rie
     main="decompose() avec mod�le additif",                                    # Titre du graphique
     xlab='Temps', ylab="Int�r�t")                                              # Titre des axes
points(PizzaAdd$trend, type='l', col="red")                                     # Tendance de la s�rie
points(PizzaAdd$trend+PizzaAdd$seasonal, type='l', col='blue')                  # Courbe de la s�rie simul�e
legend('topleft', col=c("darkgrey","red",'blue'), lwd=c(2,1,1), bg="white",     # Param�tres de la l�gende
       legend=c(expression(X[t]), expression(m[t]), expression(m[t]+s[t])))     # Texte de la l�gende


# D�composition : mod�le multiplicative
#--------------------------------------
PizzaMult = decompose(Pizza, type="multiplicative")     # D�composition en mod�le multiplicatif
plot(PizzaMult)                                         # Plot de la d�composition

plot(Pizza, lwd=2, col="darkgrey",                                               # Plot de la s�rie
     main="decompose() avec mod�le multiplicatif",                               # Titre du graphique
     xlab='Temps', ylab="Int�r�t")                                               # Titre des axes
points(PizzaMult$trend, type='l', col="red")                                     # Tendance de la s�rie
points(PizzaMult$trend*PizzaMult$seasonal, type='l', col='blue')                 # Courbe de la s�rie simul�e
legend('topleft', col=c("darkgrey","red",'blue'), lwd=c(2,1,1),  bg="white",     # Param�tres de la l�gende
       legend=c(expression(X[t]), expression(m[t]), expression(m[t]*s[t])))      # Texte de la l�gende


#----------------------------------------------------------------------------------------------------------------
# Lissage exponentielle triple : m�thode de Holt-Winters
#----------------------------------------------------------------------------------------------------------------
PizzaHW_MAM = ets(Pizza, model="MAM")     # Erreur : MULT, tendence : ADD, saison : MULT 
summary(PizzaHW_MAM)                      # Param�tres du mod�le

PizzaHW_MMM = ets(Pizza, model="MMM")     # Erreur : MULT, tendence : MULT, saison : MULT
summary(PizzaHW_MMM)                      # Param�tres du mod�le

PizzaPredHW_MAM = forecast(PizzaHW_MAM, h=12)                                                # Pr�diction sur 12 mois
plot(PizzaPredHW_MAM, xlim=c(2017,2020), ylim=c(50,100), xaxt="n")                           # Plot de la pr�diction
axis(1, at=seq(2017,2020,1), labels=seq(2017,2020,1))                                        # Texte de l'abscisse
points(Pizza2019, type="l", lwd=2, col="darkgreen")                                          # Vraies valeurs
abline(v=seq(2017,2020,1), col="red", lty="dotted")                                          # Lignes verticales
legend('topleft', col=c("black","darkgreen",'blue'), lwd=c(1,2,2), cex=0.8,  bg="white",     # Param�tres de la l�gende
       legend=c("Anciennes valeurs","Vraies valeurs","Pr�diction"))                          # Texte de la l�gende

PizzaPredHW_MMM = forecast(PizzaHW_MMM, h=12)                                               # Pr�diction sur 12 mois
plot(PizzaPredHW_MMM, xlim=c(2017,2020), ylim=c(50,100), xaxt="n")                          # Plot de la pr�diction
axis(1, at=seq(2017,2020,1), labels=seq(2017,2020,1))                                       # Texte de l'abscisse
points(Pizza2019, type="l", lwd=2, col="darkgreen")                                         # Vraies valeurs
abline(v=seq(2017,2020,1), col="red", lty="dotted")                                         # Lignes verticales
legend('topleft', col=c("black","darkgreen",'blue'), lwd=c(1,2,2), cex=0.8, bg="white",     # Param�tres de la l�gende
       legend=c("Anciennes valeurs","Vraies valeurs","Pr�diction"))                         # Texte de la l�gende


#----------------------------------------------------------------------------------------------------------------
# Passage au log()
#----------------------------------------------------------------------------------------------------------------
# Chronogramme
#-------------
MatX = matrix(data=log(Pizza), nrow=12)
Min = apply(MatX, 2, min)
Max = apply(MatX, 2, max)
YearMin = c(2005:2019)
YearMax = c(2004:2018)

plot(log(Pizza), lwd=2, main="LOG de l'int�r�t pour le mot 'Pizza' en France", xlab="Temps", ylab="log(Int�r�t)")
points(YearMin, Min, col="blue", type = "l")
points(YearMax, Max, col="red", type = "l")


# D�composition
#--------------
PizzaLog = decompose(log(Pizza), type="additive")     # D�composition en mod�le additif
plot(PizzaLog)                                        # Plot de la d�composition

plot(log(Pizza), lwd=2, col="darkgrey",                                                  # Plot de la s�rie
     main="decompose() avec mod�le additif du LOG",                                      # Titre du graphique
     xlab='Temps', ylab="Int�r�t")                                                       # Titre des axes
points(PizzaLog$trend, type='l', col="red")                                              # Tendance de la s�rie
points(PizzaLog$trend+PizzaLog$seasonal, type='l', col='blue')                           # Courbe de la s�rie simul�e
legend('topleft', col=c("darkgrey","red",'blue'), lwd=c(2,1,1), cex=0.8, bg="white",     # Param�tres de la l�gende
       legend=c(expression(log(X[t])), expression(m[t]), expression(m[t]+s[t])))         # Texte de la l�gende


# Lissage exponentielle triple : m�thode de Holt-Winters
#-------------------------------------------------------
PizzaHWlog = ets(log(Pizza), model="AAA")     # Erreur : ADD, tendence : ADD, saison : ADD
summary(PizzaHWlog)                           # Param�tres du mod�le

PizzaPredHWlog = forecast(PizzaHWlog, h=12)              # Pr�diction sur 12 mois
for (i in c(2,4:7)){                                     # R�transformation
  PizzaPredHWlog[i] = lapply(PizzaPredHWlog[i], exp)     # Appliquer exp() � tous les �l�ments n�cessaires
}
plot(PizzaPredHWlog, xlim=c(2017,2020), ylim=c(50,100), xaxt="n")                           # Plot de la pr�diction
axis(1, at=seq(2017,2020,1), labels=seq(2017,2020,1))                                       # Texte de l'abscisse
points(Pizza2019, type="l", lwd=2, col="darkgreen")                                         # Vraies valeurs
abline(v=seq(2017,2020,1), col="red", lty="dotted")                                         # Lignes verticales
legend('topleft', col=c("black","darkgreen",'blue'), lwd=c(1,2,2), cex=0.8, bg="white",     # Param�tres de la l�gende
       legend=c("Anciennes valeurs","Vraies valeurs","Pr�diction"))                         # Texte de la l�gende


#----------------------------------------------------------------------------------------------------------------
# Mod�lisation ARMA/SARMA, ARIMA/SARIMA
#----------------------------------------------------------------------------------------------------------------
# Fonctions d'autocorr�lation
#---------------------------
par(mfrow=c(1,2))
acf(Pizza, type="covariance", main="Covariance de Pizza")        # Covariance
acf(Pizza, type="correlation", main="Corr�lations de Pizza")     # Corr�lations
par(mfrow=c(1,1))


# Diff�renciation (�liminer saisonnalit� et tendance)
#----------------------------------------------------
# S�rie originale
par(mfrow=c(1,3))
plot(diff(diff(Pizza, lag=12), lag=1))                                              # Saisonnalit� 12, tendance
acf(diff(diff(Pizza, lag=12), lag=1), main="diff(diff(Pizza, lag=12), lag=1)")      # ACF
pacf(diff(diff(Pizza, lag=12), lag=1), main="diff(diff(Pizza, lag=12), lag=1)")     # PACF
par(mfrow=c(1,1))

# LOG de la s�rie
par(mfrow=c(1,3))
plot(diff(diff(log(Pizza), lag=12), lag=1))                                                   # Saisonnalit� 12, tendance
acf(diff(diff(log(Pizza), lag=12), lag=1), main="diff(diff(log(Pizza), lag=12), lag=1)")      # ACF
pacf(diff(diff(log(Pizza), lag=12), lag=1), main="diff(diff(log(Pizza), lag=12), lag=1)")     # PACF
par(mfrow=c(1,1))


# Mod�lisation SARIMA
#--------------------
# SARIMA(0,1,1)(0,1,0)
PizzaSARIMAlog = Arima(log(Pizza), order=c(0,1,1), seasonal=c(0,1,0))     # SARIMA(0,1,1)(0,1,0)
summary(PizzaSARIMAlog)
par(mfrow=c(1,2))
acf(PizzaSARIMAlog$residuals, main="R�sidus SARIMA(0,1,1)(0,1,0)")        # ACF
pacf(PizzaSARIMAlog$residuals, main="R�sidus SARIMA(0,1,1)(0,1,0)")       # PACF
par(mfrow=c(1,1))
Box.test(PizzaSARIMAlog$residuals, lag=45)                                # Test de blancheur

# SARIMA(0,1,1)(0,1,1)
PizzaSARIMAlog = Arima(log(Pizza), order=c(0,1,1), seasonal=c(0,1,1))     # SARIMA(0,1,1)(0,1,1)
summary(PizzaSARIMAlog)
par(mfrow=c(1,2))
acf(PizzaSARIMAlog$residuals, main="R�sidus SARIMA(0,1,1)(0,1,1)")        # ACF
pacf(PizzaSARIMAlog$residuals, main="R�sidus SARIMA(0,1,1)(0,1,1)")       # PACF
par(mfrow=c(1,1))
Box.test(PizzaSARIMAlog$residuals, lag=45)                                # Test de blancheur
t_stat(PizzaSARIMAlog)                                                    # Significativit� des coefficients
cor.arma(PizzaSARIMAlog)                                                  # Autocorr�lations

# Pr�diction SARIMA
PizzaPredSARIMAlog = forecast(PizzaSARIMAlog, h=12)
for (i in c(4:7,9)){                                             # R�transformation
  PizzaPredSARIMAlog[i] = lapply(PizzaPredSARIMAlog[i], exp)     # Appliquer exp() � tous les �l�ments n�cessaires
}
plot(PizzaPredSARIMAlog, xlim=c(2017,2020), ylim=c(50,100), xaxt="n")                       # Plot de la pr�diction
axis(1, at=seq(2017,2020,1), labels=seq(2017,2020,1))                                       # Texte de l'abscisse
points(Pizza2019, type="l", lwd=2, col="darkgreen")                                         # Vraies valeurs
abline(v=seq(2017,2020,1), col="red", lty="dotted")                                         # Lignes verticales
legend('topleft', col=c("black","darkgreen",'blue'), lwd=c(1,2,2), cex=0.8, bg="white",     # Param�tres de la l�gende
       legend=c("Anciennes valeurs","Vraies valeurs","Pr�diction"))                         # Texte de la l�gende

# Mod�lisation automatique
#-------------------------
# SARIMA
PizzaAUTOlog = auto.arima(log(Pizza), ic="aic")                         # Choix automatique bas� sur l'AIC
summary(PizzaAUTOlog)
par(mfrow=c(1,2))
acf(PizzaAUTOlog$residuals, main="R�sidus SARIMA(2,1,2)(2,1,2)")        # ACF
pacf(PizzaAUTOlog$residuals, main="R�sidus SARIMA(2,1,2)(2,1,2)")       # PACF
par(mfrow=c(1,1))
Box.test(PizzaAUTOlog$residuals, lag=45)                                # Test de blancheur
t_stat(PizzaAUTOlog)                                                    # Significativit� des coefficients
cor.arma(PizzaAUTOlog)                                                  # Autocorr�lations

# Pr�diction
PizzaPredAUTOlog = forecast(PizzaAUTOlog, h=12)
for (i in c(4:7,9)){                                         # R�transformation
  PizzaPredAUTOlog[i] = lapply(PizzaPredAUTOlog[i], exp)     # Appliquer exp() � tous les �l�ments n�cessaires
}
plot(PizzaPredAUTOlog, xlim=c(2017,2020), ylim=c(50,100), xaxt="n")                         # Plot de la pr�diction
axis(1, at=seq(2017,2020,1), labels=seq(2017,2020,1))                                       # Texte de l'abscisse
points(Pizza2019, type="l", lwd=2, col="darkgreen")                                         # Vraies valeurs
abline(v=seq(2017,2020,1), col="red", lty="dotted")                                         # Lignes verticales
legend('topleft', col=c("black","darkgreen",'blue'), lwd=c(1,2,2), cex=0.8, bg="white",     # Param�tres de la l�gende
       legend=c("Anciennes valeurs","Vraies valeurs","Pr�diction"))                         # Texte de la l�gende


#------------------------------------------------------------------------------------------------
# Choix de mod�le
#------------------------------------------------------------------------------------------------
plot(Pizza2019, lwd=2, xlim=c(2019,2019.92), xaxt="n",                       # Vraies valeurs
     main="Comparaison des mod�les", xlab="Temps")                           # Titres
abline(v=seq(2019,2020,length.out=13), lty="dotted", col="grey")             # Lignes verticales
axis(1,at=seq(2019,2020,length.out=13),                                      # Textes de l'abscisse
     labels=c("Jan.", "F�v.", "Mars", 
              "Avr.", "Mai", "Juin", 
              "Juil.", "Ao�t", "Sep.", 
              "Oct.", "Nov.", "D�c.", "Jan."))
points(PizzaPredHW_MAM$mean, type="l", col="red")                            # PizzaPredHW_MAM
points(PizzaPredHW_MMM$mean, type="l", col="green")                          # PizzaPredHW_MMM
points(PizzaPredHWlog$mean, type="l", col="blue")                            # PizzaPredHWlog
points(PizzaPredSARIMAlog$mean, type="l", col="cyan")                        # PizzaPredSARIMAlog
points(PizzaPredAUTOlog$mean, type="l", col="magenta")                       # PizzaPredAUTOlog
legend('topleft', col=seq(1:6), lwd=c(2,1,1,1,1,1), cex=0.8, bg="white",     # Param�tres de la l�gende
       legend=c("Vraies valeurs",                                            # Texte de la l�gende
                "Holt-Winters (M,A,M)",
                "Holt-Winters (M,M,M)",
                "Holt-Winters (A,A,A) - log",
                "SARIMA (0,1,1)(0,1,1) - log", 
                "SARIMA (2,1,2)(2,1,2) - log"))
