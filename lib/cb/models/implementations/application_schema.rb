module Cb
  module Models
    class ApplicationSchema
      attr_accessor :did, :title, :requirements,
                    :apply_url, :submit_service_url, :is_shared_apply,
                    :total_questions, :total_required_questions, :questions

      def initialize(args = {})
        return if args.nil?

        # Job Info related
        @did                      = args['JobDID'] || ''
        @title       			        = args['JobTitle'] || ''
        @requirements             = args['Requirements'] || ''

        # Apply URL related
        @submit_service_url       = args['ApplicationSubmitServiceURL'] || ''
        @apply_url       			    = args['ApplyURL'] || ''
        @is_shared_apply          = (args['IsSharedApply'].downcase == 'true')

        # Question related
        @total_questions       		= args['TotalQuestions'] || ''
        @total_required_questions	= args['TotalRequiredQuestions'] || ''
        @total_questions          = @total_questions.to_i if Cb::Utils::Api.is_numeric? @total_questions
        @total_required_questions = @total_required_questions.to_i if Cb::Utils::Api.is_numeric? @total_required_questions

        @questions = []
        if args.has_key?('Questions')
          unless args['Questions'].empty?
            args['Questions']['Question'].each do | qq |
              @questions << ApplicationSchema::QuestionSchema.new(qq)
            end
          end
        end
      end # Initialize
    end # CbApplicationSchema

    #################################################################
    class ApplicationSchema::QuestionSchema
      attr_accessor :id, :type, :required, :format, :text, :answers

      def initialize(args = {})
        return if args.nil?

        @id       = args['QuestionID'] || ''
        @type     = args['QuestionType'] || ''
        @required = (args['IsRequired'].downcase == 'true')
        @format   = args['ExpectedResponseFormat'] || ''
        @text     = args['QuestionText'] || ''

        @answers = []
        if args.has_key?('Answers')
          unless args['Answers'].empty?
            args['Answers']['Answer'].each do | aa |
              @answers << ApplicationSchema::AnswerSchema.new(aa)
            end
          end
        end
      end
    end # CbQuestionSchema

    #################################################################
    class ApplicationSchema::AnswerSchema
      attr_accessor :question_id, :id, :text

      def initialize(args = {})
        return if args.nil?

        @question_id    = args['QuestionID']
        @id             = args['AnswerID']
        @text           = args['AnswerText']
      end
    end # CbAnswerSchema
  end
end
