require 'spec_helper'

module Cb
  describe Cb::Clients::Job do
    context '.search' do
      context 'when the search returns with results' do
        before(:each) do
          content = { ResponseJobSearch: {
            SearchMetaData: { SearchLocations: { SearchLocation: ['tahiti'] } },
            Results: { JobSearchResult: [Hash.new] } } }

          stub_request(:get, uri_stem(Cb.configuration.uri_job_search)).
            to_return(:body => content.to_json)
        end

        it 'returns an array of job models' do
          search = Cb.job.search(Hash.new)
          search.api_error.should == false
          search[0].is_a?(Cb::Models::Job).should == true
        end
      end

      context 'When the search returns only one result' do
        before(:each) do
          content = {
            ResponseJobSearch: {
              SearchMetaData: { SearchLocations: { SearchLocation: ['tahiti'] } },
              Results: { JobSearchResult: {} }
            }
          }
          stub_request(:get, uri_stem(Cb.configuration.uri_job_search)).to_return(:body => content.to_json)
        end

        it 'returns an array of job models' do
          search = Cb.job.search(Hash.new)
          search.api_error.should == false
          search[0].is_a?(Cb::Models::Job).should == true
        end
      end

    end

    context '.find_by_criteria' do
      before :each do
        stub_request(:get, uri_stem(Cb.configuration.uri_job_find)).
          to_return(:body => { ResponseJob: { Job: Hash.new } }.to_json)
      end

      let(:criteria) { Cb::Criteria::Job::Details.new }

      context 'when a criteria object is the input param' do
        it 'returns a single job model' do
          model = Cb::Clients::Job.find_by_criteria(criteria)
          expect(model).to be_an_instance_of Cb::Models::Job
        end
      end
    end

    context '.find_by_did' do
      context 'when a string job did is input' do
        let(:criteria) { double(Cb::Criteria::Job::Details) }

        before(:each) { Cb::Criteria::Job::Details.stub(:new).and_return(criteria) }

        it 'constructs a criteria object, sets the input did, and calls #find_by_criteria' do
          did = 'fake-did'

          Cb::Clients::Job.should_receive(:find_by_criteria).with(criteria)
          criteria.should_receive(:did=).with(did)

          Cb::Clients::Job.find_by_did(did)
        end
      end
    end
  end
end
