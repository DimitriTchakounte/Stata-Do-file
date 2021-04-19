    **** Paper title : The effect of women's bargaining power within couple on contraceptive use in Cameroon****

 cd"C:\Users\user\Desktop\TCHAKS\Gates\Data and code"
 set maxvar 32000
 use CMIR71FL.DTA, clear
 set more off

*I) The final sample
   *a) Removing pregnant women at the time of the survey
		 keep if v213==0
   *b) Keeping married women or women living with a partner 
	     keep if v501==1 | v501==2
 
*II) The dependant variable : current contraceptive use
         recode v312 (0=0 "not using") (8 9 13=1 "Traditional") (1/7 11 14 16 17 18=2 "Modern"), gen(contraceptive_use)
         recode v312 (0 8 9 13=0 "not using/traditional") (1/7 11 14 16 17 18=1 "Modern"), gen(contraceptive_use2)
         lab var contraceptive_use "Current Contraceptive method use"

*III)   The independent variables
     *1) Variable of interest : Women's Bargaining power. There are 6 dimensions:
   
	  *a) Dimension of Women's role in decision making	
		  * On its own health care 
          recode v743a (1 2=1 "Wife alone/jointly") (4 5 6=2 "husband/other"),gen(decisionmaking_healthcare)
		  lab var decisionmaking_healthcare "Woman decision making on health care"
		  
		  *On daily need purchases
		  recode v743c (1 2=1 "Wife alone") (4 5 6=2 "Both husband and wife"),gen(decisionmaking_dailypurchase)
		  lab var decisionmaking_dailypurchase "Woman decision making on daily need purchases"
		  
		  * On food to be cooked each day 
		  recode v743e (1 2=1 "Wife alone") (4 5 6=2 "Both husband and wife"),gen(decisionmaking_food)
		  lab var decisionmaking_food "Woman decision making on foods to be cooked each day"
	  
		  *On visits to family or relatives 
		  recode v743d (1 2=1 "Wife alone/jointly") (4 5 6=2 "Husband/others"),gen(decisionmaking_visits_family)
		  lab var decisionmaking_visits_family "Woman decision making on visits to family and relatives "

		  * On large purchases
	      recode v743b (1 2=1 "Wife alone/jointly") (4 5 6=2 "Husband/other"),gen(decisionmaking_largpurchase)
		  lab var decisionmaking_largpurchase "Woman decision making on large purchases"
		  
          * On contraceptive use
		  clonevar sex_HH=v151
		  hotdeck v632a, store by(sex_HH) imput(1) // simple imputation of 34% MV of v739 by hotdeck method
		  sort sex_HH v632a
	      preserve
		    use "imp1.dta", clear
		    gen n=_n
		    rename v632a v632a_n
		    drop sex_HH
		    save, replace
	      restore
		  merge 1:1 _n using "imp1.dta"
	      erase "imp1.dta" 
	      drop _merge
	      recode v632a_n (1 3=1 "Woman alone or jointly") (2 6=0 "husband or someone else"), gen(DM_contraception)
		  		  
	   *b) Dimension of Economic dependance/position 
	       * Worked last 12 months 
          recode v731 (2 3=1 "yes") (0 1=0 "no"), gen(worked)
	  
	       * Own a land alone or jointly
	      recode v745b (1 2 3=1 "yes") (0=0 "no"), gen(land)
	  
	      * Own a house alone or jointly
	      recode v745a (1 2 3=1 "yes") (0=0 "no"), gen(house)

      *c) Dimension 2: Control over resources  
       	* Decision-making on repondent's earns		   
  	     hotdeck v739, store by(sex_HH) imput(1) // simple imputation of 34% MV of v739 by hotdeck method
	     sort sex_HH v739
	      preserve
		    use "imp1.dta", clear
		    gen n=_n
		    rename v739 v739_n
		    drop sex_HH
		    save, replace
	      restore
	     merge 1:1 _n using "imp1.dta"
	     erase "imp1.dta"
	     drop _merge
         recode v739_n (1 2 =1 "Woman alone or jointly") (4 5=2 "husband or someone else"), gen(DM_woman_earns)

       * Decision-making on husband's earns
 	     hotdeck v743f, store by(sex_HH) imput(1) // simple imputation of 34% MV of v739 by hotdeck method
	     sort sex_HH v743f
	      preserve
		    use "imp1.dta", clear
		    gen n=_n
		    rename v743f v743f_n
		    drop sex_HH
		    save, replace
	      restore
	     merge 1:1 _n using "imp1.dta"
	     erase "imp1.dta"
	     drop _merge
         recode v743f_n (1 2=1 "Woman alone or jointly") (4 6 7=2 "husband or someone else"), gen(DM_husband_earns)

	  * Mobile phone use for financial transactions
 	     hotdeck v169b, store by(sex_HH) imput(1) // simple imputation of 34% MV of v739 by hotdeck method
	     sort sex_HH v169b
	      preserve
		    use "imp1.dta", clear
		    gen n=_n
		    rename v169b v169b_n
		    drop sex_HH
		    save, replace
	      restore
	     merge 1:1 _n using "imp1.dta"
	     erase "imp1.dta"
	     drop _merge
         clonevar phone= v169b_n 
	  	  
	    * Ownership of an account
		 clonevar account= v170		  
		  	 
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
		        		  
	  *f) Construction of the Women Bargaining Power Composite Index (WBPCI)
	     * Frequency weight
		   generate f_wgt = int(v005/1000000) 
           lab var f_wgt "weight computation"
		  
		 * Multiple Correspondance Analysis (MCA)
		   global mcavarlist1 decisionmaking_healthcare decisionmaking_largpurchase /*
		     */ decisionmaking_visits_family DM_contraception DM_woman_earns DM_husband_earns /*
			 */ phone account worked land house beat_goes_out beat_neglect beat_burns_food/*
			 */ beat_argues beat_refuse_sex 

		   mca $mcavarlist1 [fw=f_wgt], dimension(2)
		   alpha $mcavarlist1
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
       *a) Variables of individual level : socioeconomic, demographic and cultural factors
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

		 recode v701 (8=0), gen(educ_husb)
		 quietly tab educ_husb, gen(husb_educ_level)
		 rename husb_educ_level1 h_no_education
		 rename husb_educ_level2 h_primary_education
		 rename husb_educ_level3 h_secondary_education
		 rename husb_educ_level4 h_higher_education
		 lab var h_no_education "husband is not educated"
		 lab var h_primary_education "husband primary education level"
		 lab var h_secondary_education "husband secondary education level"
		 lab var h_higher_education "husband higher education level"

	   * Age of artners		 
		 recode v013 (1 2=1 "15-24") (3 4=2 "25-34") (5 6 7=3 "35-49"), gen(age_woman)
         lab var age_woman "current age of woman (grouped)"

	   * Partner's occupational status 
		 recode v705 (1/9=1 "husband is working") (0 98=0 "husband is not working"), gen(working_partner)
		 lab var working_partner "Husband's occupational status"

	   * Religion of women
		 recode v130 (4=1 "moslem") (1 2 3=2 "christian") (5 7 96=3 "none/other"), gen(religion)
		 lab var religion "religion of woman"
		 quie ta religion, gen(Religion)
		 rename Religion1 moslem
		 rename Religion2 christian
		 rename Religion3 other

      *b) Variables of couple and household level : wealth index and number of living children	
		 gen wealth_index=v190
		 lab var wealth_index "Household wealth Index"
		 quiet ta wealth_index, gen(wealth)
		 rename wealth1 poorest
		 rename wealth2 poor
		 rename wealth3 middle
		 rename wealth4 richer
		 rename wealth5 richest
	
		 recode v218 (0=0 "none") (1/2=1 "1-2") (3/4=2 "3-4") (5 6=3 "5-6")(7/13=4 "6+"), gen(number_children)
		 lab var number_children "number of living children"
         ta number_children, gen(children)

      *c) Environemental factor
		 recode v102 (2=1 "rural") (1=0 "urban"), gen(place_of_residence)
		 lab var place_of_residence "household's Place of residence"
	
	  *d) Intermediary factors of contraception 
	    * don't want no more children
		 recode v605 (1 2 3 4 9=0 "want more") (5 6 7=1 "wants no more"), gen(want_more_child)
		 lab var want_more_child "desire of woman for more children"

       *e) Exposure of women to medias: television, radio & newspapers
		 recode v159 (0=0 "not at all") (1 2=1 "less/at least once a week"), gen(TV)
		 lab var TV "Woman Watches TV at least once a weak"
   	     recode v158 (0=0 "not at all") (1 2=1 "less/at least once a week"), gen(Radio)
		 lab var Radio "Woman listens Radio at least once a week"
   	     recode v157 (0=0 "not at all") (1 2=1 "less/at least once a week"), gen(newspaper)
		 lab var newspaper "Woman reads newspapers at least once a week"

		 
	* IV) Descriptive Statistics : univariate statistics
	   *1) Univariate statistics
	     global T contraceptive_use WBPCI i.age_woman w_primary_educ w_secondary_educ w_higher_educ /*
		  */ h_primary_education h_secondary_education h_higher_education /* 
		  */ working_partner moslem christian poor middle richer richest place_of_residence /* 
		  */ i.number_children TV Radio newspaper want_more_child

		  sum $T
		 asdoc sum $T, fs(12) font(Times New Roman) save(sum_stat.doc) replace

  * V) Econometric estimation
     *1) logistic regression model
         global X i.age_woman w_primary_educ w_secondary_educ w_higher_educ /*
		  */ h_primary_education h_secondary_education h_higher_education /* 
		  */ working_partner moslem christian poor middle richer richest place_of_residence /* 
		  */ i.number_children TV Radio newspaper want_more_child
	   
         logistic contraceptive_use2 WBPCI, vce(robust) 
		 estat ic
		 estimate store OR
		 estimate store ci
		 outreg2 [OR] using result1, word eform cti(odds ratio) replace
		 outreg2 [ci] using result2, word ci cti(95%CI)

		 logistic contraceptive_use2 WBPCI $X, vce(robust) noconst
		 estat ic
		 estimate store OR
		 estimate store ci
		 outreg2 [OR] using result21, word eform cti(odds ratio) replace
		 outreg2 [ci] using result22, word ci cti(95%CI)

