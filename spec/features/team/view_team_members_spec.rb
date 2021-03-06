require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'

describe 'View team members of my organisation' do
  context 'when logged out' do
    before { visit team_members_path }

    it_behaves_like 'not signed in'
  end

  context 'when logged in' do
    let(:organisation) { create(:organisation) }
    let(:user) { create(:user, :confirmed, email: 'me@example.gov.uk', organisation: organisation) }

    before do
      ENV['LONDON_RADIUS_IPS'] = "1.1.1.1,2.2.2.2"
      ENV['DUBLIN_RADIUS_IPS'] = "1.1.1.1,2.2.2.2"
    end

    context 'as the only user in my organisation' do
      before do
        sign_in_user user
        visit team_members_path
      end

      it 'shows my email' do
        expect(page).to have_content('me@example.gov.uk')
      end

      it 'shows my permissions' do
        expect(page).to have_content('View logs')
        expect(page).to have_content('View team members')
        expect(page).to have_content('View locations and IPs')
        expect(page).to have_content('Add and remove team members')
        expect(page).to have_content('Add and remove locations and IPs')
      end
    end

    context 'when there are many users in my organisation' do
      before do
        create(:user, :confirmed, email: 'friend@example.gov.uk', organisation: organisation)
      end

      it 'renders all users within my organisation' do
        sign_in_user user
        visit team_members_path

        expect(page).to have_content('me@example.gov.uk')
        expect(page).to have_content('friend@example.gov.uk')
      end
    end

    context 'when there are users outside of my organisation' do
      before do
        other_organisation = create(:organisation, name: 'Org 2')
        create(:user, :confirmed, email: 'stranger@example.gov.uk', organisation: other_organisation)
      end

      it 'does not include users from other organisations' do
        sign_in_user user
        visit team_members_path

        expect(page).to_not have_content('stranger@example.gov.uk')
      end
    end
  end
end
