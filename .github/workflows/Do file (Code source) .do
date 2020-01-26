 cd"Z:\Bibliothèque de la Connaissance\Travaux de recherches\Mes bases de données traitées\Intrahousehold bargaining power\Données\cmcr61dt"
 use CMCR61FL.DTA, clear
 set more off
 
    ****** PAPER TITLE : WOMEN'S BARGAINING POWER WITHIN COUPLE AND CONTRACEPTIVE USE ****

*I) Removing couples where women were pregnant at the moment of survey
		 drop if v213==1 
		 
*II) The dependant variable : current contraceptive use
         recode v312 (1/14=1 " Using one contraceptive method") (0=0 "Not using"), gen(contraceptive_use) 
         lab var contraceptive_use "Current Contraceptive use"

*III) The explanatory variables
     *1) Variable of interest is Women's Bargaining power. There are 6 dimensions:
   
	  *a) Dimension of Women's role in decision making	
		  * On its own health care 
		  recode v743a (1 2=1 "Wife alone") (4 5 6=2 "Both husband and wife"),gen(decisionmaking_healthcare)
		  lab var decisionmaking_healthcare "Woman decision making on health care"
		  
		  *On daily need purchases
		  recode v743c (1 2=1 "Wife alone") (4 5 6=2 "Both husband and wife"),gen(decisionmaking_dailypurchase)
		  lab var decisionmaking_dailypurchase "Woman decision making on daily need purchases"
		  
		  * On food to be cooked each day 
		  recode v743e (1 2=1 "Wife alone") (4 5 6=2 "Both husband and wife"),gen(decisionmaking_food)
		  lab var decisionmaking_food "Woman decision making on foods to be cooked each day"
	  
		  *On visits to family or relatives 
		  recode v743d (1 2=1 "Wife alone") (4 5 6=2 "Both husband and wife"),gen(decisionmaking_visits_family)
		  lab var decisionmaking_visits_family "Woman decision making on visits to family and relatives "

		  * On large purchases
		  recode v743b (1 2=1 "Wife alone") (4 5 6=2 "Both husband and wife"),gen(decisionmaking_largpurchase)
		  lab var decisionmaking_largpurchase "Woman decision making on large purchases"
		  
		  * On number of children
		  recode mv743g (1 2=1 "Wife alone") (4 8=2 "Both husband and wife"),gen(decisionmaking_children)
		  lab var decisionmaking_children "Woman decision making on how many children to have"
		  
	   *b) Dimension of Economic dependance/position 
	   
		  * worked during the last month
		  recode v731 (2 3=1 Yes) (0 1=2 No), gen(worked_last_month)
		  lab var worked_last_month "Wife have worked during the 12 month preceding the survey"
   
		  * Share of total household expenditures paid by women's earning
		  clonevar sex_HH=v151
		  hotdeck s820a, store by(sex_HH) imput(1) // simple imputation of 34% MV of s820a by hotdeck method
		  sort sex_HH s820a
	      gen n=_n
	      preserve
		    use "imp1.dta", clear
		    gen n=_n
		    rename s820a s820a_n
		    drop sex_HH
		    save, replace
	      restore
	      merge 1:1 _n using "imp1.dta"
	      erase "imp1.dta"
		  recode s820a_n (1 2 9 6=3 "Nothing or less than half") (3=2 "almost half") (4 5=1 "more than half or all"), gen(share_household_expenses)	 
		  lab var share_household_expenses "Share of household expenditures paid by women"
		  
		  * portion of income used for household expenses
		  hotdeck s820b, store by(sex_HH) imput(1) // simple imputation of 34% MV of s820b by hotdeck method
		  sort sex_HH s820b
	      preserve
		    use "imp1.dta", clear
		    gen n=_n
		    rename s820b s820b_n
		    drop sex_HH
		    save, replace
	      restore
		  drop _merge
	      merge 1:1 _n using "imp1.dta"
	      erase "imp1.dta"

          recode s820b_n (1 2 9 6=3 "Nothing or less than half") (3=2 "almost half") (4 5=1 "more than half or all"), gen(portion_income_expenses)
          lab var portion_income_expenses "Portion of income devoted to household expenses"
		  
		  * Property status : Own an unbuilt piece of land and a house
	      recode s1403 (1 2=1 "Yes") (3=2 "No"), gen(Owner_unbuil_land)
	      lab var Owner_unbuil_land "Owner of an unbuilt piece of land"
	
		  recode s1402 (1 2=1 "Yes") (3=2 "No"), gen(Owner_house)
	      lab var Owner_house "Owner of a house"
		  
	  *c) Control over finance dimension : how to spend woman's and husband's earning     
		 
		  *On how to spend woman's earning
		  hotdeck v739, store by(sex_HH) imput(1) // simple imputation of 34% MV of v739 by hotdeck method
		  sort sex_HH v739
	      preserve
		    use "imp1.dta", clear
		    gen n=_n
		    rename v739 v739_n
		    drop sex_HH
		    save, replace
	      restore
		  drop _merge
	      merge 1:1 _n using "imp1.dta"
	      erase "imp1.dta"

		  recode v739_n (3 4 5 6=2 "Woman don't have control") (1 2=1 "Woman have control"), gen(ord_own_revenu)
		  lab var ord_own_revenu "decision on how to spend Woman's earning"
		  		  
		  *On how to spend husband revenu
		  hotdeck v743f, store by(sex_HH) imput(1) // simple imputation of 8% MV of v743f by hotdeck method
		  sort sex_HH v743f
	      preserve
		    use "imp1.dta", clear
		    gen n=_n
		    rename v743f v743f_n
		    drop sex_HH
		    save, replace
	      restore
	      drop _merge
		  merge 1:1 _n using "imp1.dta"
	      erase "imp1.dta"

		  recode v743f_n (4 6 7=2 "Woman can not decide") (1 2=1 "Woman can decide"), gen(ord_husband_revenu)
		  lab var ord_husband_revenu "decision on how to spend husband'earning"	 
		  	 
	  *d) Dimension of attitude of woman toward women's violence
	  
         * beating is justified if wife goes out without telling him
		  recode v744a (1=2 "Yes") (0 8=1 "No"), gen(beat_goes_out)
		  lab var beat_goes_out "beating is justified if wife goes out without telling him"
		   
         * beating is justified if wife neglect the children
          recode v744b (1=2 "Yes") (0 8=1 "No"), gen(beat_neglect)
		  lab var beat_neglect "beating is justified if wife neglect the children"
		   
         * beating is justified if wife argues with husband
          recode v744c (1=2 "Yes") (0 8=1 "No"), gen(beat_argues)
		  lab var beat_argues "beating is justified if wife argues with husband"
		   
         * beating is justified if wife refuse sex
          recode v744d (1=2 "Yes") (0 8=1 "No"), gen(beat_refuse_sex)
		  lab var beat_refuse_sex "beating is justified if wife refuse sex with husband"
		   
         * beating is justified if wife burns the food
          recode v744e (1=2 "Yes") (0 8=1 "No"), gen(beat_burns_food)
          lab var beat_burns_food "beating is justified if wife burns the food"
		        		  
	  *e) Dimension of Women membership to committee associations
	      * Member of a cultural association
		  recode s1404a (1=1 Yes) (0=2 No), gen(member_cultural_Ass)
		  lab var member_cultural_Ass "Member of a cultural assocition"
          
		  * Member of a religious association
		  recode s1404b (1=1 Yes) (0=2 No), gen(member_religious_Ass)
		  lab var member_religious_Ass "Member of a religious assocition"

          * Member of a political party
	  	  recode s1404c (1=1 Yes) (0=2 No), gen(member_political_party)
		  lab var member_political_party "Member of a political party"
		  
		  * Member of a financial association (tontine)
	   	  recode s1404d (1=1 Yes) (0=2 No), gen(member_tontine)
		  lab var member_tontine "Member of a financial association (tontine)"

		  * Member of a development comittee 
	   	  recode s1404e (1=1 Yes) (0=2 No), gen(member_dev_comittee)
		  lab var member_dev_comittee "Member of a development comittee"
   
          * Member of a sportive association
		  recode s1404f (1=1 Yes) (0=2 No), gen(member_sportiv_Ass)
		  lab var member_sportiv_Ass "Member of a sportive association"
		  
		  * Member of a friendship association
		  recode s1404g (1=1 Yes) (0=2 No), gen(member_friendship_Ass)
		  lab var member_friendship_Ass "Member of a friendship association"

          * Member of a professionnal association
		  recode s1404h (1=1 Yes) (0=2 No), gen(member_prof_Ass)
		  lab var member_prof_Ass "Member of a professionnal association"
		  
		  * Member of an other type of association 
		  recode s1404i (1=1 Yes) (0=2 No), gen(member_other_type_Ass)
		  lab var member_other_type_Ass "Member of an other type of association" 

	      * Interview interrupt by the presence of husband
		  hotdeck md122a, store by(sex_HH) imput(1) // simple imputation of 21% MV of md122a by hotdeck method
		  sort sex_HH md122a
	      preserve
		    use "imp1.dta", clear
		    gen n=_n
		    rename md122a md122a_n
		    drop sex_HH
		    save, replace
	      restore
		  drop _merge
	      merge 1:1 _n using "imp1.dta"
	      erase "imp1.dta"

	 	  recode md122a_n (1 2 .=2 Yes) (0=1 No), gen(husb_presen_interview)
		  lab var husb_presen_interview "Interviewed was interupt by the presence of husband"

		 * Interview interrupt by other male's presence
		  hotdeck md122b, store by(sex_HH) imput(1) // simple imputation of 21% MV of md122a by hotdeck method
		  sort sex_HH md122b
	      preserve
		    use "imp1.dta", clear
		    gen n=_n
		    rename md122b md122b_n
		    drop sex_HH
		    save, replace
	      restore
		  drop _merge
	      merge 1:1 _n using "imp1.dta"
	      erase "imp1.dta"

		  recode md122b_n (1 2 .=2 Yes) (0=1 No), gen(othermale_presen_interview)
		  lab var othermale_presen_interview "Interviewed was interupt by the other male's presence"	 
		 
		 * Interview interrupt by adult female' presence
		  hotdeck md122c, store by(sex_HH) imput(1) // simple imputation of 21% MV of md122c by hotdeck method
		  sort sex_HH md122c
	      preserve
		    use "imp1.dta", clear
		    gen n=_n
		    rename md122c md122b_c
		    drop sex_HH
		    save, replace
	      restore
		  drop _merge
	      merge 1:1 _n using "imp1.dta"
	      erase "imp1.dta"

		  recode md122c (1 2 =2 "Yes") (0 .=1 "Non"), gen(interupt_female_adult)
		  lab var interupt_female_adult "Interviewed was interupt by adult female's presence"	 

	  *f) Construction of the Women Bargaining Power Composite Index (WBPCI)
	     * Frequency weight
		   generate f_wgt = int(v005/1000000) 
           lab var f_wgt "weight computation"
		  
		 * Multiple Correspondance Analysis (MCA)
		   global mcavarlist1 decisionmaking_healthcare decisionmaking_dailypurchase decisionmaking_largpurchase /*
		      */  decisionmaking_food decisionmaking_visits_family decisionmaking_children worked_last_month Owner_unbuil_land/*
			  */  Owner_house ord_own_revenu ord_husband_revenu share_household_expenses portion_income_expenses/*
			  */  beat_goes_out beat_neglect beat_burns_food beat_argues beat_refuse_sex member_cultural_Ass /*
			  */  member_tontine member_dev_comittee member_sportiv_Ass member_friendship_Ass member_prof_Ass /*
			  */  member_other_type_Ass member_religious_Ass member_political_party /*
			  */  husb_presen_interview othermale_presen_interview	interupt_female_adult

		   mca $mcavarlist1 [fw=f_wgt], dimension(2)
		
		 /* 2nd iteration after having removed 3 items under that did not respct the property of First Axis Ordering Consistency: 
		    husb_presen_interview*/
				
		   global mcavarlist2 decisionmaking_healthcare decisionmaking_dailypurchase decisionmaking_largpurchase /*
		      */  decisionmaking_food decisionmaking_visits_family decisionmaking_children worked_last_month Owner_unbuil_land/*
			  */  Owner_house ord_own_revenu ord_husband_revenu share_household_expenses portion_income_expenses/*
			  */  beat_goes_out beat_neglect beat_burns_food beat_argues beat_refuse_sex member_cultural_Ass /*
			  */  member_tontine member_dev_comittee member_sportiv_Ass member_friendship_Ass member_prof_Ass /*
			  */  member_other_type_Ass member_religious_Ass member_political_party	

		  mca $mcavarlist2 [fw=f_wgt], dimension(2)
		  screeplot
		  mcaplot `mcavarlist2', xline(0) yline(0) dimension(2 1) overlay origin
		  predict WBPCI, rowscores

	    * Normalization of GCI
          gen WBPCI_norm=WBPCI
	      qui sum WBPCI_norm
	      replace WBPCI_norm=WBPCI_norm-r(min)
	      lab var WBPCI_norm "standardized score of GCI"

		* Internal consistency of GCI: alpha of Cronbach
		  alpha $mcavarlist2
    	      
     *2) Control variables 	 
       *a) Variables of individual level : socioeconomic, demographic and cultural factors of partners 
         * Highest Education level of spouses  
         quiet ta v106, gen(education_level)
		 rename education_level1 w_no_education
		 rename education_level2 w_primary_educ
		 rename education_level3 w_secondary_educ
		 rename education_level4 w_higher_educ
		 lab var w_no_education "woman no education level"
		 lab var w_primary_educ "woman primary education level"
		 lab var w_secondary_educ "woman secondary education level"
		 lab var w_higher_educ "woman higher education level"
	
		 gen educ_husb=v701
		 replace educ_husb=. if  educ_husb==9
		 quietly tab educ_husb, gen(husb_educ_level)
		 rename husb_educ_level1 h_no_education
		 rename husb_educ_level2 h_primary_education
		 rename husb_educ_level3 h_secondary_education
		 rename husb_educ_level4 h_higher_education
		 lab var h_no_education "husband is not educated"
		 lab var h_primary_education "husband primary education level"
		 lab var h_secondary_education "husband secondary education level"
		 lab var h_higher_education "husband higher education level"
	
	   * Age of partners
		 gen woman_age=v012
		 lab var woman_age "current age of woman"
	
		 gen age2=woman_age^2
	
		 gen age_husband= v730 
		 egen mean_age=mean(age_husband) if age_husband<89
		 quiet ta mean_age
		 replace age_husband=40 if age_husband>=89
		 lab var age_husband "current age of husband"

	   * Partner's Occupational status 
		 recode v705 (1/96=1 "husband is working") (0=0 "husband is not working"), gen(working_partner)
		 lab var working_partner "Husband's occupational status"

	   * Religion of women
		 recode v130 (3=1 "moslem") (1 2 5=2 "christian") (4 7 96=3 "other"), gen(religion)
		 lab var religion "religion of woman"
		 quie ta religion, gen(Religion)
		 rename Religion1 moslem
		 rename Religion2 christian
		 rename Religion3 other
	
	    *Ethnicity of women (Peuhl)
		 recode v131 (1 2 3=1 "peuhl/arabe choa/haoussa") (5 6=2 "Bamileke") (8=3 "Béti/Bassa/Mbam") (4 7 9 10=4 "other"), gen(ethnicity)
		 lab var ethnicity "Ethnicity of woman"
		 quiet ta ethnicity, gen(Ethnicity)
		 rename Ethnicity1 peuhl
		 rename Ethnicity2 Bamileke
		 rename Ethnicity3 Béti_Bassa_Mbam
		 rename Ethnicity4 other_ethnicity
	
      *b) Variables of couple and household level : wealth index and number of children	
		 gen wealth_index=v190
		 lab var wealth_index "Household wealth Index"
		 quiet ta wealth_index, gen(wealth)
		 rename wealth1 poorest
		 rename wealth2 poor
		 rename wealth3 middle
		 rename wealth4 richer
		 rename wealth5 richest
	
	     gen number_children=v218
		 lab var number_children "number of living children"
 
      *c) Community or environemental factor
		 recode v102 (2=1 "rural") (1=0 "urban"), gen(place_of_residence)
		 lab var place_of_residence "household's Place of residence"
	
	  *d) Intermediary factors of contraception 
	    * don't want no more children
		 recode v605 (1 2 3 9=0 "want more") (4 5 6 7=1 "do not want no more"), gen(want_more_child)
		 lab var want_more_child "woman want more children"

	    * Husband approve PF
		 quie ta s720a religion, row
		 recode s720a (1=1 "husband approve") (2 8=0 "husband don't approve"), gen(husband_approve_PF)
		 lab var husband_approve_PF "Husband approve PF"
	
       *e) Exposition of women to medias: Television and radio
		 recode v159 (0=0 "not at all") (1 2 3=1 " at least once a week"), gen(freq_watch_TV1)
		 lab var freq_watch_TV1 "Woman Watches TV at least once a weak"
   	     recode v158 (0=0 "not at all") (1 2 3=1 "less or at least once a week"), gen(freq_list_Radio1)
		 lab var freq_list_Radio1 "Woman listens Radio at least once a week"
    
 * IV) Descriptive Statistics : univariate and bivariate (Cross tabulation) statistic
	   *1) Univariate statistic
	     global T contraceptive_use WBPCI_norm woman_age age_husband w_no_education w_primary_educ w_secondary_educ  /*
		  */ w_higher_educ h_no_education h_primary_education h_secondary_education h_higher_education /* 
		  */ working_partner moslem christian other number_children poorest poor middle richer richest /* 
		  */ place_of_residence freq_watch_TV1 freq_list_Radio1 want_more_child husband_approve_PF
		  
		 asdoc sum $T, fs(12) font(Times New Roman) save(sum_stat.doc) replace

	   *2) Bivariate statistic	   
		 global D WBPCI_norm woman_age age_husband w_no_education w_primary_educ w_secondary_educ  /*
		  */ w_higher_educ h_no_education h_primary_education h_secondary_education h_higher_education /* 
		  */ working_partner moslem christian other number_children poorest poor middle richer richest /* 
		  */ place_of_residence freq_watch_TV1 freq_list_Radio1 want_more_child husband_approve_PF

		asdoc sum $D, by(contraceptive_use) save(sum_stat_cross.doc) replace
		asdoc tabstat $D, by(contraceptive_use) col(variables) stat(mean tstat)  save(sum_stat10.doc) replace
		 
		 * Chi square test between contraceptive use and qualitative variables
		 ta w_no_education contraceptive_use, chi2 
		 ta w_primary_educ contraceptive_use, chi2
		 ta w_secondary_educ contraceptive_use, chi2
		 ta w_higher_educ contraceptive_use, chi2	
		 ta working_woman contraceptive_use, chi2 
		 ta h_no_education contraceptive_use, chi2
		 ta h_primary_education contraceptive_use, chi2
		 ta h_secondary_education contraceptive_use, chi2
		 ta h_higher_education contraceptive_use, chi2
		 ta working_partner contraceptive_use, chi2
		 ta moslem contraceptive_use, chi2
		 ta christian contraceptive_use, chi2
		 ta other contraceptive_use, chi2 
		 ta poorest contraceptive_use, chi2
		 ta poor contraceptive_use, chi2
		 ta middle contraceptive_use, chi2
		 ta richer contraceptive_use, chi2
	     ta richest contraceptive_use, chi2
		 ta place_of_residence contraceptive_use, chi2
		 ta freq_watch_TV1 contraceptive_use, chi2
		 ta freq_list_Radio1 contraceptive_use, chi2
		 ta want_more_child contraceptive_use, chi2 
		 ta husband_approve_PF contraceptive_use, chi2

* V) Econometric estimation
   *1) probit model estimation
    global X woman_age age2 w_primary_educ w_secondary_educ w_higher_educ /*
		  */ age_husband  h_primary_education h_secondary_education h_higher_education /* 
		  */ working_partner moslem christian poor middle richer richest place_of_residence /* 
		  */ number_children freq_watch_TV1 freq_list_Radio1 want_more_child husband_approve_PF
		  
    probit contraceptive_use WBPCI $X, vce(robust)
	mfx compute // Marginal effects
	outreg2 using probit_result, word mfx replace 

   *2) Robustness checks : Probit model with sample selection 
	use CMCR61FL.DTA, clear
	recode v213 (1=0 "yes") (0=1 "No"), gen(currently_pregnant)
    gen ideal=v613
	egen mean_ideal=mean(ideal) if ideal<96
	tab mean_ideal
    replace ideal=6 if ideal==96
	heckprobit contraceptive_use WBPCI $X , select(currently_pregnant=WBPCI $X ideal)
	mfx
	outreg2 using heckprobit_result, word mfx replace
