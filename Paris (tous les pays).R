#----------------------------------------------------------------------------------------------------------------
# Packages utilis�s
#----------------------------------------------------------------------------------------------------------------
library(caschrono)
library(forecast)


#----------------------------------------------------------------------------------------------------------------
# S�rie temporelle 'Paris'
#----------------------------------------------------------------------------------------------------------------
data = read.csv("Paris (tous les pays).csv", skip=1, col.names=c("Mois","France"), row.names=1)     # Chargement
Paris = ts(data[1:(nrow(data)-12),], start=c(2004, 1), frequency=12)                                # S�rie sans 2019
Paris2019 = ts(data[(nrow(data)-11):nrow(data),], start=c(2019, 1), frequency=12)                   # Donn�es de 2019


#----------------------------------------------------------------------------------------------------------------
# Statistique d�scriptive
#----------------------------------------------------------------------------------------------------------------
# Chronogramme
#-------------
plot(Paris, lwd=2, main="Int�r�t pour le mot 'Paris' partout dans le monde", xlab="Temps", ylab="Int�r�t")     # Plot de la s�rie
points(x=c(2015, 2015.835), y=c(44, 100), pch=21, col="red", cex=2, lwd=3)                                     # Valeurs aberrantes


# Valeurs aberrantes
#-------------------
Paris[133] = (Paris[132] + Paris[134]) / 2
Paris[143] = (Paris[142] + Paris[144]) / 2

MatX = matrix(data=Paris, nrow=12)     # La s�rie en forme de matrix
Min = apply(MatX, 2, min)              # D�terminer les minimums par ann�e
Max = apply(MatX, 2, max)              # D�terminer les maximums par ann�e
YearMin = c(2004:2018)                 # Les ann�es minimum
YearMax = c(2005:2019)                 # Les ann�es maximum

plot(Paris, lwd=2, main="Int�r�t pour le mot 'Paris' partout dans le monde", xlab="Temps", ylab="Int�r�t")     # Plot de la s�rie
points(YearMin, Min, col="blue", type = "l")                                                                   # Courbe minimum
points(YearMax, Max, col="red", type = "l")                                                                    # Courbe maximum


# Month-plot
#-----------
monthplot(Paris, main="Monthplot de 'Paris'", ylab="Paris")     # Month-plot de la s�rie


# Lag-plot
#---------
lag.plot(Paris, lags=12, main="Lag-plot de 'Paris'")     # Lag-plot de la s�rie


# D�composition : mod�le additive
#--------------------------------
ParisAdd = decompose(Paris, type="additive")     # D�composition en mod�le additif
plot(ParisAdd)                                   # Plot de la d�composition

plot(Paris, lwd=2, col="darkgrey",                                               # Plot de la s�rie
     main="decompose() avec mod�le additif",                                     # Titre du graphique
     xlab='Temps', ylab="Int�r�t")                                               # Titre des axes
points(ParisAdd$trend, type='l', col="red")                                      # Tendance de la s�rie
points(ParisAdd$trend+ParisAdd$seasonal, type='l', col='blue')                   # Courbe de la s�rie simul�e
legend('topright', col=c("darkgrey","red",'blue'), lwd=c(2,1,1), bg="white",     # Param�tres de la l�gende
       legend=c(expression(X[t]), expression(m[t]), expression(m[t]+s[t])))      # Texte de la l�gende


# D�composition : mod�le multiplicative
#--------------------------------------
ParisMult = decompose(Paris, type="multiplicative")     # D�composition en mod�le multiplicatif
plot(ParisMult)                                         # Plot de la d�composition

plot(Paris, lwd=2, col="darkgrey",                                               # Plot de la s�rie
     main="decompose() avec mod�le multiplicatif",                               # Titre du graphique
     xlab='Temps', ylab="Int�r�t")                                               # Titre des axes
points(ParisMult$trend, type='l', col="red")                                     # Tendance de la s�rie
points(ParisMult$trend*ParisMult$seasonal, type='l', col='blue')                 # Courbe de la s�rie simul�e
legend('topright', col=c("darkgrey","red",'blue'), lwd=c(2,1,1), bg="white",     # Param�tres de la l�gende
       legend=c(expression(X[t]), expression(m[t]), expression(m[t]*s[t])))      # Texte de la l�gende


#----------------------------------------------------------------------------------------------------------------
# Lissage exponentielle triple : m�thode de Holt-Winters
#----------------------------------------------------------------------------------------------------------------
ParisHW_AAA = ets(Paris, model="AAA", ic="aic")      # Erreur : ADD,  tendance : ADD,  saison : ADD
ParisHW_MAdA = ets(Paris, model="MAA", ic="aic")     # Erreur : MULT, tendance : ADD,  saison : ADD
ParisHW_MAdM = ets(Paris, model="MAM", ic="aic")     # Erreur : MULT, tendance : MULT, saison : MULT
ParisHW_MMdM = ets(Paris, model="MMM", ic="aic")     # Erreur : MULT, tendance : MULT, saison : MULT

paste0("Mod�le : ", ParisHW_AAA$method, ", AIC = ", round(ParisHW_AAA$aic, 3))
paste0("Mod�le : ", ParisHW_MAdA$method, ", AIC = ", round(ParisHW_MAdA$aic, 3))
paste0("Mod�le : ", ParisHW_MAdM$method, ", AIC = ", round(ParisHW_MAdM$aic, 3))
paste0("Mod�le : ", ParisHW_MMdM$method, ", AIC = ", round(ParisHW_MMdM$aic, 3))

ParisPredHW_MAdM = forecast(ParisHW_MAdM, h=12)                                             # Pr�diction sur 12 mois
plot(ParisPredHW_MAdM, xlim=c(2017,2020), ylim=c(25,50), xaxt="n")                          # Plot de la pr�diction
axis(1, at=seq(2017,2020,1), labels=seq(2017,2020,1))                                       # Texte de l'abscisse
points(Paris2019, type="l", lwd=2, col="darkgreen")                                         # Vraies valeurs
abline(v=seq(2017,2020,1), col="red", lty="dotted")                                         # Lignes verticales
legend('topleft', col=c("black","darkgreen",'blue'), lwd=c(1,2,2), cex=0.8, bg="white",     # Param�tres de la l�gende
       legend=c("Anciennes valeurs","Vraies valeurs","Pr�diction"))                         # Texte de la l�gende

ParisPredHW_MMdM = forecast(ParisHW_MMdM, h=12)                                             # Pr�diction sur 12 mois
plot(ParisPredHW_MMdM, xlim=c(2017,2020), ylim=c(25,50), xaxt="n")                          # Plot de la pr�diction
axis(1, at=seq(2017,2020,1), labels=seq(2017,2020,1))                                       # Texte de l'abscisse
points(Paris2019, type="l", lwd=2, col="darkgreen")                                         # Vraies valeurs
abline(v=seq(2017,2020,1), col="red", lty="dotted")                                         # Lignes verticales
legend('topleft', col=c("black","darkgreen",'blue'), lwd=c(1,2,2), cex=0.8, bg="white",     # Param�tres de la l�gende
       legend=c("Anciennes valeurs","Vraies valeurs","Pr�diction"))                         # Texte de la l�gende


#----------------------------------------------------------------------------------------------------------------
# Mod�lisation ARMA/SARMA, ARIMA/SARIMA
#----------------------------------------------------------------------------------------------------------------
# Fonctions d'autocorr�lation
#---------------------------
par(mfrow=c(1,2))
acf(Paris, type="covariance", main="Covariance de Paris")        # Covariance
acf(Paris, type="correlation", main="Corr�lations de Paris")     # Corr�lations
par(mfrow=c(1,1))


# Diff�renciation (�liminer saisonnalit� et tendance)
#----------------------------------------------------
par(mfrow=c(1,3))
plot(diff(diff(Paris, lag=12), lag=1))                                              # Saisonnalit� 12, tendance
acf(diff(diff(Paris, lag=12), lag=1), main="diff(diff(Paris, lag=12), lag=1)")      # ACF
pacf(diff(diff(Paris, lag=12), lag=1), main="diff(diff(Paris, lag=12), lag=1)")     # PACF
par(mfrow=c(1,1))


# Mod�lisation SARIMA
#--------------------
# SARIMA(2,1,2)(1,1,1)
ParisSARIMA = Arima(Paris, order=c(2,1,2), seasonal=c(1,1,1))     # SARIMA(2,1,2)(1,1,1)
summary(ParisSARIMA)
par(mfrow=c(1,2))
acf(ParisSARIMA$residuals, main="R�sidus SARIMA(2,1,2)(1,1,1)")        # ACF
pacf(ParisSARIMA$residuals, main="R�sidus SARIMA(2,1,2)(1,1,1)")       # PACF
par(mfrow=c(1,1))
Box.test(ParisSARIMA$residuals, lag=45)                                # Test de blancheur
t_stat(ParisSARIMA)                                                    # Significativit� des coefficients
cor.arma(ParisSARIMA)                                                  # Autocorr�lations

# SARIMA(2,1,1)(1,1,1)
ParisSARIMA = Arima(Paris, order=c(2,1,1), seasonal=c(1,1,1))     # SARIMA(2,1,2)(1,1,1)
summary(ParisSARIMA)
par(mfrow=c(1,2))
acf(ParisSARIMA$residuals, main="R�sidus SARIMA(2,1,1)(1,1,1)")        # ACF
pacf(ParisSARIMA$residuals, main="R�sidus SARIMA(2,1,1)(1,1,1)")       # PACF
par(mfrow=c(1,1))
Box.test(ParisSARIMA$residuals, lag=45)                                # Test de blancheur
t_stat(ParisSARIMA)                                                    # Significativit� des coefficients
cor.arma(ParisSARIMA)                                                  # Autocorr�lations

# SARIMA(2,1,0)(1,1,1)
ParisSARIMA = Arima(Paris, order=c(2,1,0), seasonal=c(1,1,1))     # SARIMA(2,1,2)(1,1,1)
summary(ParisSARIMA)
par(mfrow=c(1,2))
acf(ParisSARIMA$residuals, main="R�sidus SARIMA(2,1,0)(1,1,1)")        # ACF
pacf(ParisSARIMA$residuals, main="R�sidus SARIMA(2,1,0)(1,1,1)")       # PACF
par(mfrow=c(1,1))
Box.test(ParisSARIMA$residuals, lag=45)                                # Test de blancheur
t_stat(ParisSARIMA)                                                    # Significativit� des coefficients
cor.arma(ParisSARIMA)                                                  # Autocorr�lations

# SARIMA(2,1,0)(0,1,1)
ParisSARIMA = Arima(Paris, order=c(2,1,0), seasonal=c(0,1,1))     # SARIMA(2,1,2)(1,1,1)
summary(ParisSARIMA)
par(mfrow=c(1,2))
acf(ParisSARIMA$residuals, main="R�sidus SARIMA(2,1,0)(0,1,1)")        # ACF
pacf(ParisSARIMA$residuals, main="R�sidus SARIMA(2,1,0)(0,1,1)")       # PACF
par(mfrow=c(1,1))
Box.test(ParisSARIMA$residuals, lag=45)                                # Test de blancheur
t_stat(ParisSARIMA)                                                    # Significativit� des coefficients
cor.arma(ParisSARIMA)                                                  # Autocorr�lations

# Pr�diction SARIMA
ParisPredSARIMA = forecast(ParisSARIMA, h=12)                                               # Pr�diction sur 12 mois
plot(ParisPredSARIMA, xlim=c(2017,2020), ylim=c(25,50), xaxt="n")                           # Plot de la pr�diction
axis(1, at=seq(2017,2020,1), labels=seq(2017,2020,1))                                       # Texte de l'abscisse
points(Paris2019, type="l", lwd=2, col="darkgreen")                                         # Vraies valeurs
abline(v=seq(2017,2020,1), col="red", lty="dotted")                                         # Lignes verticales
legend('topleft', col=c("black","darkgreen",'blue'), lwd=c(1,2,2), cex=0.8, bg="white",     # Param�tres de la l�gende
       legend=c("Anciennes valeurs","Vraies valeurs","Pr�diction"))                         # Texte de la l�gende

# Mod�lisation automatique
#-------------------------
# SARIMA
ParisAUTO = auto.arima(Paris, ic="aic")                         # Choix automatique bas� sur l'AIC
summary(ParisAUTO)
par(mfrow=c(1,2))
acf(ParisAUTO$residuals, main="R�sidus SARIMA(2,1,1)(2,1,1)")        # ACF
pacf(ParisAUTO$residuals, main="R�sidus SARIMA(2,1,1)(2,1,1)")       # PACF
par(mfrow=c(1,1))
Box.test(ParisAUTO$residuals, lag=45)                                # Test de blancheur
t_stat(ParisAUTO)                                                    # Significativit� des coefficients
cor.arma(ParisAUTO)                                                  # Autocorr�lations

# Pr�diction
ParisPredAUTO = forecast(ParisAUTO, h=12)                                                   # Pr�diction sur 12 mois
plot(ParisPredAUTO, xlim=c(2017,2020), ylim=c(25,50), xaxt="n")                             # Plot de la pr�diction
axis(1, at=seq(2017,2020,1), labels=seq(2017,2020,1))                                       # Texte de l'abscisse
points(Paris2019, type="l", lwd=2, col="darkgreen")                                         # Vraies valeurs
abline(v=seq(2017,2020,1), col="red", lty="dotted")                                         # Lignes verticales
legend('topleft', col=c("black","darkgreen",'blue'), lwd=c(1,2,2), cex=0.8, bg="white",     # Param�tres de la l�gende
       legend=c("Anciennes valeurs","Vraies valeurs","Pr�diction"))                         # Texte de la l�gende

# Comparaison au mod�le SARIMA
plot(ParisPredSARIMA$mean, col="blue", lwd=2, ylim=c(26,41),                                # ParisPredSARIMA
     xaxt="n", xlab="Temps", ylab="Int�r�t",                                                # Textes des axes
     main="Comparaison SARIMA vs. AUTO")                                                    # Titre
axis(1,at=seq(2019,2019.917,length.out=12),                                                 # Param�tres de l'abscisse
     labels=c("Jan.", "F�v.", "Mars",                                                       # Texte de l'abscisse
              "Avr.", "Mai", "Juin",                                                        # Texte de l'abscisse
              "Juil.", "Ao�t", "Sep.",                                                      # Texte de l'abscisse
              "Oct.", "Nov.", "D�c."))                                                      # Texte de l'abscisse
polygon(x=c(seq(2019,2019.917,length.out=12), seq(2019.917,2019,length.out=12)),            # IC 80% ParisPredAUTO
        y=c(ParisPredAUTO$upper[1:12], ParisPredAUTO$lower[12:1]),                          # IC 80% ParisPredAUTO
        col=rgb(red=1, green=0, blue=0, alpha=0.05), border=FALSE)                          # IC 80% ParisPredAUTO
points(ParisPredAUTO$mean, type="l", col="red", lwd=2)                                      # ParisPredAUTO
points(ParisPredAUTO$upper, type="l", lty="dashed", col="red")                              # Max IC 80% ParisPredAUTO
points(ParisPredAUTO$lower, type="l", lty="dashed", col="red")                              # Min IC 80% ParisPredAUTO
polygon(x=c(seq(2019,2019.917,length.out=12), seq(2019.917,2019,length.out=12)),            # IC 80% ParisPredSARIMA
        y=c(ParisPredSARIMA$upper[1:12], ParisPredSARIMA$lower[12:1]),                      # IC 80% ParisPredSARIMA
        col=rgb(red=0, green=0, blue=1, alpha=0.05), border=FALSE)                          # IC 80% ParisPredSARIMA
points(ParisPredSARIMA$upper, type="l", lty="dashed", col="blue")                           # Max IC 80% ParisPredSARIMA
points(ParisPredSARIMA$lower, type="l", lty="dashed", col="blue")                           # Min IC 80% ParisPredSARIMA
legend("bottomleft", lwd=c(2,1,2,1), lty=c("solid","dashed","solid","dashed"), cex=0.8,     # Param�tres de la l�gende
       col=c("blue","blue","red","red"), bg="white",                                        # Param�tres de la l�gende
       legend=c("Mod. SARIMA - moyenne", "Mod. SARIMA - intervalle de confiance � 80%",     # Texte de la l�gende
                "Mod. AUTO - moyenne", "Mod. AUTO - intervalle de confiance � 80%"))        # Texte de la l�gende


#------------------------------------------------------------------------------------------------
# Choix de mod�le
#------------------------------------------------------------------------------------------------
plot(Paris2019, lwd=2, xlim=c(2019,2019.917), xaxt="n",                     # Vraies valeurs
     main="Comparaison des mod�les", xlab="Temps")                          # Titres
abline(v=seq(2019,2020,length.out=13), lty="dotted", col="grey")            # Lignes verticales
axis(1,at=seq(2019,2020,length.out=13),                                     # Textes de l'abscisse
     labels=c("Jan.", "F�v.", "Mars", 
              "Avr.", "Mai", "Juin", 
              "Juil.", "Ao�t", "Sep.", 
              "Oct.", "Nov.", "D�c.", "Jan."))
points(ParisPredHW_MAdM$mean, type="l", col="red")                          # ParisPredHW_MAdM
points(ParisPredHW_MMdM$mean, type="l", col="green")                        # ParisPredHW_MMdM
points(ParisPredSARIMA$mean, type="l", col="blue")                          # ParisPredSARIMA
points(ParisPredAUTO$mean, type="l", col="cyan")                            # ParisPredAUTO
legend('topright', col=seq(1:5), lwd=c(2,1,1,1,1), cex=0.8, bg="white",     # Param�tres de la l�gende
       legend=c("Vraies valeurs",                                           # Texte de la l�gende
                "Holt-Winters (M,Ad,M)",
                "Holt-Winters (M,Md,M)",
                "SARIMA (2,1,0)(0,1,1)", 
                "SARIMA (2,1,1)(2,1,1)"))
