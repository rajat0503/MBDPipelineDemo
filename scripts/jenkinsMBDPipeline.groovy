pipeline {
   agent any
   environment {
       PATH = 'C:\\Program Files\\MATLAB\\R2020a\\bin;${PATH}'   // Windows agent
       }
    stages{
        stage('Stage 1 : Model in Loop ') {
            steps
            {
                echo 'Model in Loop Testing In Progress'    
                build 'Test_Model_in_Loop'
            }  
        }
        stage('Stage 2 : Code Gen ') {
            steps
            { 
                echo 'Code Gen : Build Process '
                build 'Code Generation'
            }       
        }
        stage('Stage 3 : Back2Back Test ') {
            steps
            {
                 echo 'Back2Back Test '
                 build 'Test_Model_SiL'
            }       
            
        }
        stage('Stage 4 : MISRA Analysis ') {
            steps
            {
               build 'Misra_Analysis'
            }
            post {
                success {
                            emailext body: 'Success' , subject: 'Static Analysis Passed' , to: 'rarora@mathworks.com'
                        }    
                }
        } 
    }
}   